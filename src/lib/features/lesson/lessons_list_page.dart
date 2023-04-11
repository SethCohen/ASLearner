import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/google_provider.dart';

class Lesson {
  Lesson(
      {required this.cardCount,
      required this.title,
      required this.description});

  Lesson.fromMap(Map<String, Object?> data)
      : this(
          cardCount: data['cardCount'] as int,
          title: data['title'] as String,
          description: data['description'] as String,
        );

  final int cardCount;
  final String title;
  final String description;

  Map<String, Object?> toMap() {
    return {
      'cardCount': cardCount,
      'title': title,
      'description': description,
    };
  }
}

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final decksQuery = FirebaseFirestore.instance
        .collection('decks')
        .orderBy('title')
        .withConverter<Lesson>(
          fromFirestore: (snapshot, _) => Lesson.fromMap(snapshot.data()!),
          toFirestore: (deck, _) => deck.toMap(),
        );
    return FirestoreListView<Lesson>(
      query: decksQuery,
      itemBuilder: (context, deckSnapshot) {
        Lesson deckData = deckSnapshot.data();
        String deckId = deckSnapshot.id;

        return StreamBuilder<DocumentSnapshot>(
          stream: _getUserDeckProgress(context, deckId),
          builder: (context, snapshot) {
            int userDeckCardCount = 0;

            if (snapshot.hasData && snapshot.data!.exists) {
              userDeckCardCount = snapshot.data!['cardCount'];
            }

            return _buildListItem(context, deckId, deckData, userDeckCardCount);
          },
        );
      },
    );
  }

  Stream<DocumentSnapshot> _getUserDeckProgress(
      BuildContext context, String deckId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(context.read<GoogleSignInProvider>().user!.uid)
        .collection('deckProgress')
        .doc(deckId)
        .snapshots();
  }

  Color _lessonColour(cardsCompleted, cardsTotal) =>
      cardsTotal == cardsCompleted
          ? Colors.green
          : cardsCompleted > 0
              ? Colors.orange
              : Colors.black38;

  Widget _buildListItem(BuildContext context, String deckId, Lesson deck,
          int cardsCompleted) =>
      Card(
        child: ListTile(
            title: Text(deck.title),
            subtitle: Text(deck.description),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                '${deck.cardCount - cardsCompleted}',
                style: TextStyle(
                    color: _lessonColour(cardsCompleted, deck.cardCount)),
              ),
              Icon(Icons.check_circle,
                  color: _lessonColour(cardsCompleted, deck.cardCount)),
            ]),
            onTap: () => _navigateToLesson(context, deckId, deck)),
      );

  void _navigateToLesson(BuildContext context, String deckId, Lesson deck) =>
      Navigator.pushNamed(
        context,
        '/${deck.title.toLowerCase().replaceAll(' ', '_')}',
        arguments: {
          'lessonId': deckId,
          'lessonData': deck,
        },
      );
}
