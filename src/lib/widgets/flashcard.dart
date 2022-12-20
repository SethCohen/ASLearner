import 'package:flutter/material.dart';

class Flashcard extends StatelessWidget {
  const Flashcard({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 7,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            children: [
              Text(
                data['title'],
                style: const TextStyle(fontSize: 20),
              ),
              Image.network(data['assetUrl'])
            ],
          )),
        ),
      ),
    );
  }
}
