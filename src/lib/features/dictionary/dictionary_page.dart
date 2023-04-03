import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import '../flashcard/flashcard.dart';
import '../flashcard/flashcard_model.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final flashcardsQuery = FirebaseFirestore.instance
        .collectionGroup('cards')
        .where('type', isEqualTo: 'immutable')
        .orderBy('title')
        .withConverter<FlashcardModel>(
          fromFirestore: (snapshot, _) =>
              FlashcardModel.fromMap(snapshot.data()!),
          toFirestore: (flashcard, _) => flashcard.toMap(),
        );

    // TODO add search bar

    return FirestoreQueryBuilder<FlashcardModel>(
      query: flashcardsQuery,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint('error ${snapshot.error}');
          return Text('error ${snapshot.error}');
        }

        return SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              snapshot.docs.length,
              (index) {
                if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                  snapshot.fetchMore();
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.2,
                  ),
                  child: Flashcard(
                    card: snapshot.docs[index].data(),
                    type: CardType.dictionary,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
