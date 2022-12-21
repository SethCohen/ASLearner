import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            children: [
              Text(
                widget.data['title'],
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(widget.data['assetUrl'])),
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      })),
              Visibility(
                visible: _isVisible,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.data['instructions'].length != 0
                      ? widget.data['instructions']
                      : "Lorem Ipsum"),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
