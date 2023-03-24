import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../models/review_model.dart';
import '../widgets/flashcard.dart';

class Review extends StatefulWidget {
  const Review({super.key, required this.cards});
  final List<ReviewModel> cards;

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  int _currentCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.cards[0].deckId),
            ),
            body: Column(
              children: [
                _buildFlashcards(widget.cards),
                // TODO set prograss indicator location fixed to bottom of screen
                _buildProgressTextIndicator(),
                _buildProgressBarIndicator(),
              ],
            )));
  }

  void _handleIndex() => setState(() {
        bool isCompleted = _currentCardIndex == widget.cards.length - 1;
        if (isCompleted) {
          Navigator.pop(context);
        } else {
          _currentCardIndex++;
        }
      });

  List<Widget> _getFlashcards(List<ReviewModel> cards) => cards
      .map((card) => Flashcard(
            card: FlashcardModel.fromMap(
              {
                card.cardTitle: card.cardTitle,
                card.cardInstructions: card.cardInstructions,
                card.cardImage: card.cardImage
              },
              card.cardId,
              card.deckId,
            ),
            handleIndex: _handleIndex,
            isReview: true,
          ))
      .toList();

  Widget _buildFlashcards(List<ReviewModel> cards) => Padding(
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
        child: Text('${_currentCardIndex + 1} / ${widget.cards.length}'));
  }

  Widget _buildProgressBarIndicator() {
    return TweenAnimationBuilder(
        tween: Tween<double>(
            begin: _currentCardIndex / widget.cards.length,
            end: (_currentCardIndex + 1) / widget.cards.length),
        duration: const Duration(milliseconds: 1000),
        builder: (context, double value, child) =>
            LinearProgressIndicator(value: value));
  }
}
