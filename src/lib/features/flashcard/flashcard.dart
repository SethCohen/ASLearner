import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flashcard_model.dart';
import '../../common/utils/data_provider.dart';
import '../../common/widgets/custom_iconbutton.dart';

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
  OverlayEntry? _popupOverlayEntry;

  @override
  Widget build(BuildContext context) {
    final bool isEmptyInstructions = widget.card.instructions == '';
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.15;

    return SizedBox(
      // TODO fix responsiveness based of screen
      width: cardWidth,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            // TODO replace network images with controllable apng||video player/frame controller
            Stack(
              children: [
                _buildImage(),
                if (!_isImageBlurred && !isEmptyInstructions)
                  _buildInstructionsPopup(context),
              ],
            ),
            // TODO media controls implementation
            _buildMediaControls(),
            _buildFlashcardButtons(),
          ],
        ),
      ),
    );
  }

  Positioned _buildInstructionsPopup(BuildContext context) => Positioned(
        bottom: 8,
        right: 8,
        child: CustomIconButton(
          isSelected: _popupOverlayEntry != null,
          onPressed: () =>
              _popupOverlayEntry == null ? _showPopup(context) : _hidePopup(),
          icon: const Icon(Icons.info_outline),
        ),
      );

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

  Widget _buildInstructions(height, width) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Text(widget.card.instructions),
            ),
          ),
        ),
      );

  OverlayEntry _createPopup(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx + size.width,
        top: offset.dy + size.height / 2,
        child: _buildInstructions(size.height, size.width),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    _popupOverlayEntry = _createPopup(context);
    Overlay.of(context).insert(_popupOverlayEntry!);
  }

  void _hidePopup() {
    _popupOverlayEntry?.remove();
    _popupOverlayEntry = null;
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }
}