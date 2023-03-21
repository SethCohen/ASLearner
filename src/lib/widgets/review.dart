import 'package:asl/widgets/flashcard.dart';
import 'package:flutter/material.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  int _currentCardIndex = 0;
  int _cardsLength = 0;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final lessonId = arguments['lessonId'] as String;
    final cards = arguments['cards'] as List;
    final isReview = arguments['isReview'] as bool;

    _cardsLength = cards.length;

    return Scaffold(
      appBar: AppBar(title: Text(_convertIdToTitle(lessonId))),
      body: Column(
        children: [
          const SizedBox(height: 20),
          IndexedStack(
              index: _currentCardIndex,
              children: cards.map((card) {
                return Flashcard(
                  lessonId: lessonId,
                  cardId: card['cardId'],
                  cardData: card['cardData'],
                  handleCardIndex: _handleCardIndex,
                  isReview: isReview,
                );
              }).toList()),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('${_currentCardIndex + 1} / $_cardsLength'),
            ),
          ),
          LinearProgressIndicator(
            value: _currentCardIndex / _cardsLength,
          ),
        ],
      ),
    );
  }

  String _convertIdToTitle(String input) {
    return input.replaceAll('lesson', 'Lesson ');
  }

  void _handleCardIndex() {
    setState(() {
      if (_currentCardIndex == _cardsLength - 1) {
        Navigator.pop(context);
      } else {
        _currentCardIndex++;
      }
    });
  }
}
