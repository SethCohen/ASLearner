import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spaced_repetition/sm.dart';
import '../../features/flashcard/flashcard_model.dart';

final currentUser = FirebaseAuth.instance.currentUser!;

class UserDataUtil {
  static Future<void> updateLastLogin() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((user) {
      final userData = user.data() as Map<String, dynamic>;
      final lastLogin = userData['lastLogin'] as Timestamp;
      final lastLearnt = userData['lastLearnt'] as Timestamp;
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final loginTimeDifference = startOfDay.difference(lastLogin.toDate());
      final lastLearntTimeDifference =
          startOfDay.difference(lastLearnt.toDate());

      if (loginTimeDifference.inHours >= 24 ||
          lastLearntTimeDifference.inHours >= 24) {
        FirebaseFirestore.instance.collection('users').doc(user.id).set({
          'streak': 0,
          'lastLogin': now,
        }, SetOptions(merge: true));
      } else {
        FirebaseFirestore.instance.collection('users').doc(user.id).set({
          'lastLogin': now,
        }, SetOptions(merge: true));
      }
    }).catchError((error) {
      debugPrint(error);
    });
  }

  static Future<void> updateLastLearnt() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (user.exists) {
      user.reference.set({
        'lastLearnt': DateTime.now(),
      }, SetOptions(merge: true));
    }
  }

  static Future<void> updateStreak() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (user.exists) {
      final lastLearnt = (user.data()!['lastLearnt'] as Timestamp).toDate();
      final now = DateTime.now();
      DateTime lastStreakUpdate =
          DateTime(lastLearnt.year, lastLearnt.month, lastLearnt.day);
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(const Duration(days: 1));

      if (lastStreakUpdate == yesterday) {
        user.reference.set({
          'streak': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
    }

    UserDataUtil.updateLastLearnt();
  }

  static Future<void> updateCardProgress(
      FlashcardModel flashcard, int quality) async {
    Sm sm = Sm();

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
            'deckTitle': flashcard.deckTitle,
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

      await batch.commit();
    }
  }
}
