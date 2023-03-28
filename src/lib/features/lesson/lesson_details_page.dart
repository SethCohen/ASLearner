import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../flashcard/flashcard_model.dart';
import '../flashcard/flashcard.dart';
import 'lessons_list_page.dart';

class LessonDetails extends StatefulWidget {
  const LessonDetails(
      {super.key, required this.lessonId, required this.lessonData});
  final String lessonId;
  final Lesson lessonData;

  @override
  State<LessonDetails> createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
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
            title: Text(widget.lessonData.title),
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
      .doc(widget.lessonId)
      .collection('cards')
      .get();

  void _handleIndex() => setState(() {
        bool isCompleted = _currentCardIndex == widget.lessonData.cardCount - 1;
        if (isCompleted) {
          Navigator.pop(context);
        } else {
          _currentCardIndex++;
        }
      });

  List<Widget> _getFlashcards(List<QueryDocumentSnapshot> cards) => cards
      .map((card) => Flashcard(
            card: FlashcardModel.fromMap(card.data() as Map<String, dynamic>,
                card.id, widget.lessonId, widget.lessonData.title),
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
        child:
            Text('${_currentCardIndex + 1} / ${widget.lessonData.cardCount}'));
  }

  Widget _buildProgressBarIndicator() {
    return TweenAnimationBuilder(
        tween: Tween<double>(
            begin: _currentCardIndex / widget.lessonData.cardCount,
            end: (_currentCardIndex + 1) / widget.lessonData.cardCount),
        duration: const Duration(milliseconds: 1000),
        builder: (context, double value, child) =>
            LinearProgressIndicator(value: value));
  }
}
