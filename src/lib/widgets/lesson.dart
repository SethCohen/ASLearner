import 'package:asl/widgets/flashcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    // TODO add actual expression signs, not just alphabet | add more cards
    // TODO optional: quiz minigame at end of lesson or loop

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final lessonId = arguments['lessonId'] as String;
    final isReview = arguments['isReview'] as bool;

    return WillPopScope(
      onWillPop: () async {
        _handleInProgress(lessonId);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(_convertIdToTitle(lessonId)),
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
              stream: FirebaseFirestore.instance
                  .collection("lessons")
                  .doc(lessonId)
                  .collection('cards')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cards = snapshot.data!.docs;
                  _cardsLength = cards.length;
                  _lessonId = lessonId;

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
                            final cardData =
                                card.data() as Map<String, dynamic>;

                            return Flashcard(
                              lessonId: lessonId,
                              cardId: card.id,
                              cardData: cardData,
                              handleCardIndex: _handleCardIndex,
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
              })),
    );
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }

  void _handleCardIndex() {
    setState(() {
      if (_currentCardIndex == _cardsLength - 1) {
        _handleComplete();
        Navigator.pop(context);
      } else {
        _currentCardIndex++;
        FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .collection('progress')
            .doc(_lessonId)
            .update({'lessonCardsRemaining': FieldValue.increment(-1)});
      }
    });
  }

  void _handleInProgress(String lessonId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('progress')
        .doc(lessonId)
        .get()
        .then(
      (lessonProgress) {
        bool isNotInProgress = !lessonProgress.data()!['inProgress'];
        if (isNotInProgress) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(_user.uid)
              .collection('progress')
              .doc(lessonId)
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
