import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson_model.dart';
import '../providers/data_provider.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final decks = context.watch<DataProvider>().lessons;

    return ListView.builder(
        controller: _scrollController,
        itemCount: decks.length,
        itemBuilder: (context, index) => _buildListItem(decks[index]));
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      context.read<DataProvider>().loadMoreLessons();
    }
  }

  Color _lessonColour(cardsCompleted, cardsTotal) =>
      cardsTotal == cardsCompleted
          ? Colors.green
          : cardsCompleted > 0
              ? Colors.orange
              : Colors.black38;

  Widget _buildListItem(LessonModel deck) => Card(
        child: ListTile(
            title: Text(deck.title),
            trailing: _buildTrailing(deck),
            onTap: () => deck.navigateToLesson(context)),
      );

  Widget _buildTrailing(LessonModel deck) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          '${deck.cardsTotal - deck.cardsCompleted}',
          style: TextStyle(
              color: _lessonColour(deck.cardsCompleted, deck.cardsTotal)),
        ),
        Icon(Icons.check_circle,
            color: _lessonColour(deck.cardsCompleted, deck.cardsTotal)),
      ]);
}
