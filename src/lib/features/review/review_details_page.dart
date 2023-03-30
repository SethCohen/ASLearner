import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flashcard/flashcard_model.dart';
import 'review_model.dart';
import '../../common/utils/data_provider.dart';
import '../flashcard/flashcard.dart';

class Review extends StatefulWidget {
  const Review({super.key, required this.title, required this.cards});
  final String title;
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
              title: Text(widget.title),
            ),
            body: Column(
              children: [
                _buildFlashcards(widget.cards),
                const Spacer(flex: 1),
                _buildProgressTextIndicator(),
                _buildProgressBarIndicator(),
              ],
            )));
  }

  void _handleIndex() => setState(() {
        bool isCompleted = _currentCardIndex == widget.cards.length - 1;
        if (isCompleted) {
          context.read<DataProvider>().removeReview(widget.title);
          Navigator.pop(context);
        } else {
          _currentCardIndex++;
        }
      });

  List<Widget> _getFlashcards(List<ReviewModel> cards) => cards
      .map((card) => Flashcard(
            card: FlashcardModel.fromMap(
              {
                'title': card.cardTitle,
                'instructions': card.cardInstructions,
                'image': card.cardImage,
              },
              card.cardId,
              card.deckId,
              card.deckTitle,
            ),
            handleIndex: _handleIndex,
            type: CardType.review,
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
