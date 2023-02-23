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
  final _user = FirebaseAuth.instance.currentUser!;

  int _currentCardIndex = 0;
  int _cardsLength = 0;
  String _lessonId = '';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final lesson = arguments['lesson'] as QueryDocumentSnapshot;

    return WillPopScope(
      onWillPop: () async {
        _handleInProgress(lesson);
        return true;
      },
      child: Scaffold(
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
                  _lessonId = lesson.id;

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
                              handleCardProgress: _handleCardProgress,
                              handleCardIndex: _handleCardIndex,
                              isReview: false,
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
              })),
    );
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }

  void _handleCardProgress(DocumentSnapshot currentCard, int quality) {
    final sm = Sm();
    debugPrint('test');

    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('progress')
        .doc(_lessonId)
        .collection('cards')
        .doc(currentCard.id)
        .get()
        .then(
      (card) {
        SmResponse calculateCardProgress() {
          if (!card.exists) {
            return sm.calc(
              quality: quality,
              previousEaseFactor: 2.5,
              previousInterval: 0,
              repetitions: 0,
            );
          } else {
            return sm.calc(
              quality: quality,
              previousEaseFactor: card.data()!['easeFactor'],
              previousInterval: card.data()!['interval'],
              repetitions: card.data()!['repetitions'],
            );
          }
        }

        SmResponse progress = calculateCardProgress();
        final lastReview = DateTime.now();
        final nextReview = lastReview.add(Duration(days: progress.interval));

        card.reference.set({
          'lastReview': lastReview,
          'nextReview': nextReview,
          'easeFactor': progress.easeFactor,
          'interval': progress.interval,
          'quality': quality,
          'repetitions': progress.repetitions,
        });
      },
    );
  }

  void _handleCardIndex() {
    setState(() {
      if (_currentCardIndex == _cardsLength - 1) {
        _handleComplete();
        Navigator.pop(context);
      } else {
        _currentCardIndex++;
      }
    });
  }

  void _handleInProgress(QueryDocumentSnapshot currentLesson) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('progress')
        .doc(currentLesson.id)
        .get()
        .then(
      (lessonProgress) {
        bool isNotInProgress = !lessonProgress.data()!['inProgress'];
        if (isNotInProgress) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(_user.uid)
              .collection('progress')
              .doc(currentLesson.id)
              .update({'inProgress': true});
        }
      },
    );
  }

  void _handleComplete() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('progress')
        .doc(_lessonId)
        .get()
        .then((lessonProgress) {
      bool isNotComplete = !lessonProgress.data()!['complete'];
      if (isNotComplete) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .collection('progress')
            .doc(_lessonId)
            .update({'complete': true});
      }
    });
  }
}
