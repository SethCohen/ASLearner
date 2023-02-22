import 'package:asl/widgets/flashcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaced_repetition/main.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  int _currentCardIndex = 0;
  int _cardsLength = 0;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final lesson = arguments['lesson'] as QueryDocumentSnapshot;
    final isReview = arguments['isReview'] as bool;

    return Scaffold(
        appBar: AppBar(
          title: Text(_convertIdToTitle(lesson.id)),
          toolbarHeight: 80,
          backgroundColor: const Color(0XFF292929),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
          elevation: 10,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: lesson.reference.collection('cards').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cards = snapshot.data!.docs;
                _cardsLength = cards.length;

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Card ${_currentCardIndex + 1} of $_cardsLength',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: _currentCardIndex / _cardsLength,
                    ),
                    IndexedStack(
                        index: _currentCardIndex,
                        children: cards.map((card) {
                          return Flashcard(
                            data: card,
                            handleCard: _updateCardInProgressCollection,
                            handleCardIndex: _incrementCardIndex,
                            isReview: isReview,
                          );
                        }).toList()),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }

  void _incrementCardIndex() {
    setState(() {
      if (_currentCardIndex == _cardsLength - 1) {
        final user = FirebaseAuth.instance.currentUser!;
        final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
        final currentLesson = arguments['lesson'] as QueryDocumentSnapshot;
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('progress')
            .doc(currentLesson.id)
            .get()
            .then((value) {
          if (!value.data()!['complete']) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('progress')
                .doc(currentLesson.id)
                .update({'complete': true});
          }
        });

        Navigator.pop(context);
      } else {
        _currentCardIndex++;
      }
    });
  }

  void _updateCardInProgressCollection(
    DocumentSnapshot card,
    int quality,
  ) {
    final user = FirebaseAuth.instance.currentUser!;
    final currentLesson =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;
    final currentCard = card;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(currentLesson.id)
        .collection('cards')
        .doc(currentCard.id)
        .get()
        .then((value) {
      final sm = Sm();

      if (!value.exists) {
        final SmResponse sm2Response = sm.calc(
          quality: quality,
          previousEaseFactor: 2.5,
          previousInterval: 0,
          repetitions: 0,
        );

        final lastReviewed = DateTime.now();
        final nextReview =
            lastReviewed.add(Duration(days: sm2Response.interval));

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('progress')
            .doc(currentLesson.id)
            .collection('cards')
            .doc(currentCard.id)
            .set({
          'lastReviewed': lastReviewed,
          'nextReview': nextReview,
          'previousEaseFactor': sm2Response.easeFactor,
          'previousInterval': sm2Response.interval,
          'quality': quality,
          'repetitions': sm2Response.repetitions,
        });
      } else {
        final SmResponse sm2Response = sm.calc(
          quality: quality,
          previousEaseFactor: value.data()!['previousEaseFactor'],
          previousInterval: value.data()!['previousInterval'],
          repetitions: value.data()!['repetitions'],
        );

        final lastReviewed = DateTime.now();
        final nextReview =
            lastReviewed.add(Duration(days: sm2Response.interval));

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('progress')
            .doc(currentLesson.id)
            .collection('cards')
            .doc(currentCard.id)
            .update({
          'lastReviewed': lastReviewed,
          'nextReview': nextReview,
          'previousEaseFactor': sm2Response.easeFactor,
          'previousInterval': sm2Response.interval,
          'quality': quality,
          'repetitions': sm2Response.repetitions,
        });
      }
    });
  }
}
