import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaced_repetition/main.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({
    super.key,
    required this.handleCardIndex,
    required this.lessonId,
    required this.cardId,
    required this.cardData,
    required this.isReview,
  });

  final Function() handleCardIndex;
  final String lessonId;
  final String cardId;
  final Map<String, dynamic> cardData;
  final bool isReview;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  final _user = FirebaseAuth.instance.currentUser!;
  bool _isBlurred = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0XFF121212),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.cardData['title'],
            style: const TextStyle(fontSize: 20),
          ),
          // TODO replace network images with controllable video player
          ClipRRect(
            child: ImageFiltered(
                enabled: _isBlurred,
                imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                child: Image.network(widget.cardData['assetUrl'])),
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
                              _handleCardProgress(0);
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
                              _handleCardProgress(2);
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
                              _handleCardProgress(5);
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
                    _handleCardProgress(0);
                  },
                  child: const Text('Next'),
                ),
        ],
      ),
    );
  }

  void _handleCardProgress(int quality) {
    final sm = Sm();

    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('progress')
        .doc(widget.lessonId)
        .collection('cards')
        .doc(widget.cardId)
        .get()
        .then(
      (card) {
        SmResponse calculateCardProgress() {
          if (!card.exists) {
            return sm.calc(
              quality: quality,
              previousEaseFactor: 2.5,
              previousInterval: 0,
              repetitions: 0,
            );
          } else {
            return sm.calc(
              quality: quality,
              previousEaseFactor: card.data()!['easeFactor'],
              previousInterval: card.data()!['interval'],
              repetitions: card.data()!['repetitions'],
            );
          }
        }

        SmResponse progress = calculateCardProgress();
        final lastReview = DateTime.now();
        final nextReview = lastReview.add(Duration(days: progress.interval));

        card.reference.set({
          'lastReview': lastReview,
          'nextReview': nextReview,
          'easeFactor': progress.easeFactor,
          'interval': progress.interval,
          'quality': quality,
          'repetitions': progress.repetitions,
        });
      },
    );
  }
}
