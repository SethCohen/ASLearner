import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const pageSize = 10;

class Deck {
  final String name;
  final String description;
  final String id;

  Deck({
    required this.name,
    required this.description,
    required this.id,
  });

  factory Deck.fromMap(id, Map<String, dynamic> data) => Deck(
        name: data['name'],
        description: data['description'],
        id: id,
      );
}

class DeckCard {
  final String assetUrl;
  final String instructions;
  final String title;
  final String deckId;
  final String cardId;

  DeckCard({
    required this.assetUrl,
    required this.instructions,
    required this.title,
    required this.deckId,
    required this.cardId,
  });

  factory DeckCard.fromMap(deckId, cardId, Map<String, dynamic> data) =>
      DeckCard(
        assetUrl: data['assetUrl'],
        instructions: data['instructions'],
        title: data['title'],
        deckId: deckId,
        cardId: cardId,
      );
}

class CurrentUserInfo {
  final String id;
  final Timestamp lastLearnt;
  final Timestamp lastLogin;
  final int streak;
  final Map<String, dynamic> deckProgress;

  CurrentUserInfo({
    required this.id,
    required this.lastLearnt,
    required this.lastLogin,
    required this.streak,
    required this.deckProgress,
  });

  factory CurrentUserInfo.fromMap(id, Map<String, dynamic> data) =>
      CurrentUserInfo(
        id: id ?? '',
        lastLearnt: data['lastLearnt'] ?? Timestamp.now(),
        lastLogin: data['lastLogin'] ?? Timestamp.now(),
        streak: data['streak'] ?? 0,
        deckProgress: data['deckProgress'] ?? {},
      );
}

class DataProvider extends ChangeNotifier {
  List<Deck> _decks = [];
  List<DeckCard> _cards = [];
  late CurrentUserInfo _user;

  late DocumentSnapshot<Map<String, dynamic>> _lastDeckDoc;
  late DocumentSnapshot<Map<String, dynamic>> _lastCardDoc;

  List<Deck> get decks => _decks;
  List<DeckCard> get cards => _cards;
  CurrentUserInfo get user => _user;

  Future<void> loadUserInfo() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((user) {
      if (user.exists) {
        _user = CurrentUserInfo.fromMap(user.id, user.data()!);
      } else {
        _user = CurrentUserInfo.fromMap('', {});
      }
    });

    notifyListeners();
  }

  Future<void> loadDecks() async {
    final decks = await FirebaseFirestore.instance
        .collection('decks')
        .orderBy('name')
        .limit(pageSize)
        .get();

    _decks = decks.docs.map((doc) => Deck.fromMap(doc.id, doc.data())).toList();
    _lastDeckDoc = decks.docs.last;

    notifyListeners();
  }

  Future<void> loadCards() async {
    final cards = await FirebaseFirestore.instance
        .collectionGroup('cards')
        .orderBy('title')
        .limit(pageSize)
        .get();

    _cards = cards.docs
        .map((doc) =>
            DeckCard.fromMap(doc.reference.parent.id, doc.id, doc.data()))
        .toList();
    _lastCardDoc = cards.docs.last;

    notifyListeners();
  }

  Future<void> loadMoreDecks() async {
    final decks = await FirebaseFirestore.instance
        .collection('decks')
        .orderBy('name')
        .startAfterDocument(_lastDeckDoc)
        .limit(pageSize)
        .get();

    if (decks.docs.isEmpty) {
      return;
    }

    _decks.addAll(
        decks.docs.map((doc) => Deck.fromMap(doc.id, doc.data())).toList());
    _lastDeckDoc = decks.docs.last;

    notifyListeners();
  }

  Future<void> loadMoreCards() async {
    final cards = await FirebaseFirestore.instance
        .collectionGroup('cards')
        .orderBy('title')
        .startAfterDocument(_lastCardDoc)
        .limit(pageSize)
        .get();

    _cards.addAll(cards.docs
        .map((doc) =>
            DeckCard.fromMap(doc.reference.parent.id, doc.id, doc.data()))
        .toList());
    _lastCardDoc = cards.docs.last;

    notifyListeners();
  }

  Future<void> loadData() async {
    await loadUserInfo();
    await loadDecks();
    // await loadCards();

    notifyListeners();
  }
}
