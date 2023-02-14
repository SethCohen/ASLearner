import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO get all cards from user's in progress collection and allow the user to review over them either by lesson or by all cards
    return const Center(child: CircularProgressIndicator());
  }
}
