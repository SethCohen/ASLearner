import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'lesson_model.dart';
import '../flashcard/flashcard_model.dart';
import '../flashcard/flashcard.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key, required this.lesson});
  final LessonModel lesson;

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  int _currentCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO optional: quiz minigame at end of lesson or loop

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.lesson.title),
          ),
          body: FutureBuilder<QuerySnapshot>(
              future: _getCardsFuture(),
              builder: (context, snapshot) => snapshot.hasData
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _buildFlashcards(snapshot.data!.docs),
                        const Spacer(flex: 1),
                        _buildProgressTextIndicator(),
                        _buildProgressBarIndicator(),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()))),
    );
  }

  Future<QuerySnapshot> _getCardsFuture() => FirebaseFirestore.instance
      .collection("decks")
      .doc(widget.lesson.id)
      .collection('cards')
      .get();

  void _handleIndex() => setState(() {
        bool isCompleted = _currentCardIndex == widget.lesson.cardsTotal - 1;
        if (isCompleted) {
          Navigator.pop(context);
        } else {
          _currentCardIndex++;
        }
      });

  List<Widget> _getFlashcards(List<QueryDocumentSnapshot> cards) => cards
      .map((card) => Flashcard(
            card: FlashcardModel.fromMap(card.data() as Map<String, dynamic>,
                card.id, widget.lesson.id, widget.lesson.title),
            handleIndex: _handleIndex,
            isReview: false,
          ))
      .toList();

  Widget _buildFlashcards(List<QueryDocumentSnapshot<Object?>> cards) =>
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: IndexedStack(
          index: _currentCardIndex,
          children: _getFlashcards(cards),
        ),
      );

  Widget _buildProgressTextIndicator() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerRight,
        child: Text('${_currentCardIndex + 1} / ${widget.lesson.cardsTotal}'));
  }

  Widget _buildProgressBarIndicator() {
    return TweenAnimationBuilder(
        tween: Tween<double>(
            begin: _currentCardIndex / widget.lesson.cardsTotal,
            end: (_currentCardIndex + 1) / widget.lesson.cardsTotal),
        duration: const Duration(milliseconds: 1000),
        builder: (context, double value, child) =>
            LinearProgressIndicator(value: value));
  }
}
