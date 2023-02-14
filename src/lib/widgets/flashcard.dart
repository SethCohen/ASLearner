import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({
    super.key,
    required this.handleCardIndex,
    required this.data,
    required this.handleCard,
  });

  final Function(DocumentSnapshot, int) handleCard;
  final Function() handleCardIndex;
  final QueryDocumentSnapshot data;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _isBlurred = true;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.data.data() as Map<String, dynamic>;

    return Card(
      color: const Color(0XFF121212),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              widget.data['title'],
              style: const TextStyle(fontSize: 20),
            ),
          ),
          // TODO replace network images with controllable video player
          ClipRRect(
            child: ImageFiltered(
                enabled: _isBlurred,
                imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                child: Image.network(data['assetUrl'])),
          ),
          // TODO add media control buttons: stop, prev frame, play/pause, next frame, playback speed
          // TODO add instructional body text
          Visibility(
              visible: !_isBlurred,
              // TODO differentiate between a Lesson Flashcard and a Review Flashcard,
              // and only show the difficulty buttons on a Review Flashcard.
              // A Lesson Flashcard should only have a "Next" button.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.handleCardIndex();
                        widget.handleCard(widget.data, 0);
                      });
                    },
                    child: const Text('Hard'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.handleCardIndex();
                        widget.handleCard(widget.data, 2);
                      });
                    },
                    child: const Text('Medium'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.greenAccent,
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.handleCardIndex();
                        widget.handleCard(widget.data, 5);
                      });
                    },
                    child: const Text('Easy'),
                  ),
                ],
              )),
          Visibility(
            visible: _isBlurred,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                setState(() {
                  _isBlurred = !_isBlurred;
                });
              },
              child: const Text('Reveal'),
            ),
          )
        ],
      ),
    );
  }
}
