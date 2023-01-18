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
  int _cardsLength = 0;

  @override
  Widget build(BuildContext context) {
    final lesson =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

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
                final cards = snapshot.data!.docs.map((document) {
                  final data = document.data() as Map<String, dynamic>;
                  _cardsLength = snapshot.data!.docs.length;
                  return Flashcard(
                    handleCardIndex: _incrementCardIndex,
                    data: data,
                  );
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 360,
                        child: IndexedStack(
                          index: _currentCardIndex,
                          children: cards,
                        ),
                      ),
                    ),
                  ),
                );
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

  void _incrementCardIndex() {
    setState(() {
      if (_currentCardIndex == _cardsLength - 1) {
        // TODO mark lesson as complete in database
        Navigator.pop(context);
      } else {
        _currentCardIndex++;
      }
    });
  }
}
