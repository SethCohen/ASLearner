import 'dart:ui';

import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({
    super.key,
    required this.handleCardIndex,
    required this.data,
  });
  final Function() handleCardIndex;
  final Map<String, dynamic> data;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _isBlurred = true;

  @override
  Widget build(BuildContext context) {
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
                child: Image.network(widget.data['assetUrl'])),
          ),
          // TODO add media control buttons: stop, prev frame, play/pause, next frame, playback speed
          // TODO add instructional body text
          Visibility(
              visible: !_isBlurred,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO implement spaced-repetition algorithm
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.handleCardIndex();
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
