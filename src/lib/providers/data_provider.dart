import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spaced_repetition/sm.dart';
import '../models/lesson_model.dart';
import '../models/flashcard_model.dart';
import '../models/review_model.dart';

final currentUser = FirebaseAuth.instance.currentUser!;
const pageSize = 5;

class DataProvider extends ChangeNotifier {
  List<LessonModel> _lessons = [];
  Map<String, List<ReviewModel>> _reviews = {};

  late DocumentSnapshot<Map<String, dynamic>> _lastDeckDoc;

  List<LessonModel> get lessons => _lessons;
  Map<String, List<ReviewModel>> get reviews => _reviews;

  Future<void> loadLessons() async {
    final lessons = await FirebaseFirestore.instance
        .collection('decks')
        .orderBy('title')
        .limit(pageSize)
        .get();

    _lessons = await Future.wait(lessons.docs.map((doc) async {
      // Gets the progress of the current user for each deck
      final userProgress = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('deckProgress')
          .doc(doc.id)
          .get();

      // If the user has not started the lesson, the cardCount will be 0
      return userProgress.exists
          ? LessonModel.fromMap(doc.id, userProgress['cardCount'], doc.data())
          : LessonModel.fromMap(doc.id, 0, doc.data());
    }).toList());

    _lastDeckDoc = lessons.docs.last;

    notifyListeners();
  }

  Future<List<LessonModel>> loadMoreLessons() async {
    final decks = await FirebaseFirestore.instance
        .collection('decks')
        .orderBy('name')
        .startAfterDocument(_lastDeckDoc)
        .limit(pageSize)
        .get();

    // If there are no more decks to fetch, return the current list of lessons
    if (decks.docs.isEmpty) {
      return _lessons;
    }

    // Gets the progress of the current user for each deck
    final currentUser = FirebaseAuth.instance.currentUser!;
    final deckProgressDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('deckProgress')
        .where(FieldPath.documentId,
            whereIn: decks.docs.map((doc) => doc.id).toList())
        .get();
    _lessons = [];
    for (final deck in decks.docs) {
      final deckProgress = deckProgressDocs.docs
          .firstWhere((doc) => doc.id == deck.id)['cardCount'];

      // Adds the deck to the list of lessons
      _lessons.add(LessonModel.fromMap(deck.id, deckProgress, deck.data()));
    }

    notifyListeners();

    return _lessons;
  }

  Future<void> loadReviews() async {
    try {
      final reviews = await FirebaseFirestore.instance
          .collectionGroup('cards')
          .where('nextReview', isLessThan: DateTime.now())
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      final reviewModelList = reviews.docs
          .map((doc) => ReviewModel.fromMap(doc.id, doc.data()))
          .toList();
      _reviews =
          groupBy(reviewModelList, (ReviewModel review) => review.deckTitle);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
  }

  Future<void> updateCardProgress(FlashcardModel flashcard, int quality) async {
    Sm sm = Sm();

    // TODO remove flashcard from reviews list if flashcard is in reviews list

    // Gets card progress for the current user
    final card = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('deckProgress')
        .doc(flashcard.deckId)
        .collection('cards')
        .doc(flashcard.cardId)
        .get();

    if (card.exists) {
      final cardData = card.data()!;

      // Calculates the new card progress
      final smResponse = sm.calc(
          previousEaseFactor: cardData['easeFactor'],
          previousInterval: cardData['interval'],
          quality: quality,
          repetitions: cardData['repetitions']);

      // Updates the card progress
      card.reference.update({
        'lastReview': DateTime.now(),
        'nextReview': DateTime.now().add(Duration(days: smResponse.interval)),
        'easeFactor': smResponse.easeFactor,
        'interval': smResponse.interval,
        'repetitions': smResponse.repetitions,
      });
    } else {
      // Calculates the new card progress
      final smResponse = sm.calc(
          previousEaseFactor: 2.5,
          previousInterval: 0,
          quality: quality,
          repetitions: 0);

      final batch = FirebaseFirestore.instance.batch();
      batch.set(

          // Creates a new card progress record
          card.reference,
          {
            'lastReview': DateTime.now(),
            'nextReview':
                DateTime.now().add(Duration(days: smResponse.interval)),
            'easeFactor': smResponse.easeFactor,
            'interval': smResponse.interval,
            'repetitions': smResponse.repetitions,
            'userId': currentUser.uid,
            'deckId': flashcard.deckId,
            'title': flashcard.title,
            'instructions': flashcard.instructions,
            'image': flashcard.image,
          },
          SetOptions(merge: true));

      // Updates the deck progress record
      final deckRec = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('deckProgress')
          .doc(flashcard.deckId);
      batch.set(deckRec, {'cardCount': FieldValue.increment(1)},
          SetOptions(merge: true));
      _lessons = _lessons
          .map((lesson) => lesson.id == flashcard.deckId
              ? lesson.copyWith(cardsCompleted: lesson.cardsCompleted + 1)
              : lesson)
          .toList();

      await batch.commit();

      notifyListeners();
    }
  }
}
