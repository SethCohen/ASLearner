import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../providers/data_provider.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({
    super.key,
    required this.handleIndex,
    required this.card,
    required this.isReview,
  });

  final void Function() handleIndex;
  final FlashcardModel card;
  final bool isReview;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _isImageBlurred = true;

  @override
  Widget build(BuildContext context) {
    final bool isEmptyInstructions = widget.card.instructions == '';

    return SizedBox(
      width: 300, // TODO make responsive
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            // TODO replace network images with controllable apng||video player/frame controller
            _buildImage(),
            // TODO media controls implementation
            _buildMediaControls(),
            _buildFlashcardButtons(),
            // TODO replace instructions with FAB over and on bottom right of image
            if (!_isImageBlurred && !isEmptyInstructions) _buildInstructions()
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String text, int quality, Color color) =>
      TextButton(
        style: TextButton.styleFrom(foregroundColor: color),
        onPressed: () => _handleButtonPress(widget.card, quality),
        child: Text(text),
      );

  Widget _buildMediaControls() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.stop),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_previous),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_next),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.speed),
          ),
        ],
      );

  Widget _buildTitle() => Text(
        widget.card.title,
        style: Theme.of(context).textTheme.titleMedium,
      );

  Widget _buildImage() => ClipRRect(
        child: ImageFiltered(
            enabled: _isImageBlurred,
            imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
            child: Image.network(widget.card.image)),
      );

  void _handleButtonPress(FlashcardModel flashcard, int quality) {
    context.read<DataProvider>().updateCardProgress(flashcard, quality);
    widget.handleIndex();
  }

  Widget _buildFlashcardButtons() {
    if (_isImageBlurred) {
      return TextButton(
        onPressed: () => setState(() => _isImageBlurred = !_isImageBlurred),
        child: const Text('Reveal'),
      );
    }

    if (widget.isReview) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDifficultyButton('Hard', 0, Colors.redAccent),
          _buildDifficultyButton('Medium', 2, Colors.blueAccent),
          _buildDifficultyButton('Easy', 5, Colors.greenAccent),
        ],
      );
    }

    return TextButton(
      onPressed: () => _handleButtonPress(widget.card, 0),
      child: const Text('Next'),
    );
  }

  Widget _buildInstructions() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: SingleChildScrollView(
            child: Text(widget.card.instructions),
          ),
        ),
      );
}
