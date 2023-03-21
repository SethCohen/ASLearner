import 'package:asl/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          MediaQuery.of(context).size.height * 0.20) {
        context.read<DataProvider>().loadMoreDecks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final decks = context.watch<DataProvider>().decks;
    final user = context.watch<DataProvider>().user;

    return ListView.builder(
      controller: _scrollController,
      itemCount: decks.length,
      itemBuilder: (context, index) {
        final userDeckProgress = user.deckProgress[decks[index].id] ??
            {'isCompleted': false, 'isInProgress': false, 'cards': {}};
        final iconColour = _lessonColour(userDeckProgress);

        return Card(
          child: ListTile(
              title: Text(decks[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userDeckProgress['cards'].length.toString(),
                    style: TextStyle(color: iconColour),
                  ),
                  Icon(Icons.check_circle, color: iconColour),
                ],
              ),
              onTap: () => Navigator.pushNamed(
                    context,
                    '/lesson',
                    arguments: {
                      'deckName': decks[index].name,
                      'isReview': false,
                    },
                  )),
        );
      },
    );
  }

  Color _lessonColour(
    Map<String, dynamic> currentLessonProgress,
  ) {
    return currentLessonProgress['isCompleted']
        ? Colors.green
        : currentLessonProgress['isInProgress']
            ? Colors.orange
            : Colors.black38;
  }
}
