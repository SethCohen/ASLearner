import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({
    super.key,
    required this.data,
    required this.handleCardIndex,
    required this.handleCardProgress,
    required this.isReview,
  });

  final Function(DocumentSnapshot, int) handleCardProgress;
  final Function() handleCardIndex;
  final QueryDocumentSnapshot data;
  final bool isReview;

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
          Text(
            widget.data['title'],
            style: const TextStyle(fontSize: 20),
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
          _isBlurred
              ? widget.isReview
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            setState(() {
                              widget.handleCardIndex();
                              widget.handleCardProgress(widget.data, 0);
                            });
                          },
                          child: const Text('Hard'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            setState(() {
                              widget.handleCardIndex();
                              widget.handleCardProgress(widget.data, 2);
                            });
                          },
                          child: const Text('Medium'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.greenAccent,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            setState(() {
                              widget.handleCardIndex();
                              widget.handleCardProgress(widget.data, 5);
                            });
                          },
                          child: const Text('Easy'),
                        ),
                      ],
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isBlurred = !_isBlurred;
                        });
                      },
                      child: const Text('Reveal'),
                    )
              : TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    widget.handleCardIndex();
                    widget.handleCardProgress(widget.data, 0);
                  },
                  child: const Text('Next'),
                ),
        ],
      ),
    );
  }
}
