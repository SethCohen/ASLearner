import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _user = FirebaseAuth.instance.currentUser!;

  Stream<List<Map<String, dynamic>>> _getCardsToReview() {
    // TODO fix rebuild on stream change not working
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .collection("progress")
        .snapshots()
        .asyncMap(
      (lessonsSnapshot) async {
        final lessonCards = await Future.wait(
          lessonsSnapshot.docs.map(
            (lesson) {
              final lessonId = lesson.id;
              return lesson.reference
                  .collection('cards')
                  .where('nextReview', isLessThan: DateTime.now())
                  .get()
                  .then(
                (cards) {
                  return cards.docs.map(
                    (card) {
                      final cardId = card.id;
                      final cardData = card.data();
                      return {
                        'lessonId': lessonId,
                        'cardId': cardId,
                        'cardData': cardData,
                      };
                    },
                  ).toList();
                },
              );
            },
          ),
        );

        return lessonCards.expand((cards) => cards).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: _getCardsToReview(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final cards = snapshot.data!;

              final foldedCards = cards.fold(
                <String, List<Map<String, dynamic>>>{},
                (previousValue, element) {
                  final lessonId = element['lessonId'] as String;
                  final card = {
                    'cardId': element['cardId'] as String,
                    'cardData': element['cardData'] as Map<String, dynamic>
                  };

                  if (previousValue.containsKey(lessonId)) {
                    previousValue[lessonId]!.add(card);
                  } else {
                    previousValue[lessonId] = [card];
                  }

                  return previousValue;
                },
              );

              if (foldedCards.isEmpty) {
                return const Text('No cards to review');
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.33,
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('Review All'),
                        trailing: Text(cards.length.toString()),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/review',
                            arguments: {
                              'lessonId': 'All Cards',
                              'cards': cards,
                              'isReview': true,
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: foldedCards.length,
                        itemBuilder: (context, index) {
                          final lessonId = foldedCards.keys.elementAt(index);
                          final lessonTitle = _convertIdToTitle(lessonId);

                          return Card(
                            child: ListTile(
                                title: Text(lessonTitle),
                                trailing: Text(
                                    foldedCards[lessonId]!.length.toString()),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/review',
                                    arguments: {
                                      'lessonId': lessonId,
                                      'cards': foldedCards[lessonId]!,
                                      'isReview': true,
                                    },
                                  );
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }
}
