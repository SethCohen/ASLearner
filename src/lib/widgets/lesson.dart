import 'package:asl/widgets/flashcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  int _currentCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lesson =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
        appBar: AppBar(
          title: Text(_convertIdToTitle(lesson.id)),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: lesson.reference.collection('cards').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cards = snapshot.data!.docs.map((document) {
                  final data = document.data() as Map<String, dynamic>;
                  return Flashcard(data: data);
                }).toList();

                return Center(
                    child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      cards[_currentCardIndex],
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentCardIndex =
                                      (_currentCardIndex - 1) % cards.length;
                                });
                              },
                              child: const Text('Previous'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentCardIndex =
                                      (_currentCardIndex + 1) % cards.length;
                                });
                              },
                              child: const Text('Next'),
                            ),
                          ])
                    ],
                  ),
                ));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }
}
