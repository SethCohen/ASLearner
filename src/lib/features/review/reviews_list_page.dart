import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common/utils/data_provider.dart';
import '../authentication/google_provider.dart';
import 'review_model.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Map<String, List<ReviewModel>> _decks = {};
  late Future<QuerySnapshot> _nextReviewFuture;

  @override
  void initState() {
    super.initState();
    context.read<DataProvider>().loadReviews();

    _nextReviewFuture = _getNextReview();
  }

  @override
  Widget build(BuildContext context) {
    _decks = context.watch<DataProvider>().reviews;

    if (_decks.isEmpty) {
      // TODO cleanup
      return Center(
        child: FutureBuilder(
            future: _nextReviewFuture,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final card =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;
              final formattedDate = DateFormat.yMMMd()
                  .add_jm()
                  .format((card['nextReview'] as Timestamp).toDate());

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      'No reviews available. Please come back again later.'),
                  snapshot.data!.docs.isEmpty
                      ? const Text('Please do a lesson first to get a review.')
                      : Text('Next review: $formattedDate'),
                ],
              );
            }),
      );
    }

    final allCards = _decks.values.expand((element) => element).toList();
    return Column(
      children: [
        Card(
            child: ListTile(
                title: const Text('Review All'),
                trailing: Text('${allCards.length}'),
                onTap: () => _navigateToReview('Review All', allCards))),
        Expanded(
          child: ListView.builder(
              itemCount: _decks.length,
              itemBuilder: (context, index) => _buildListItem(index)),
        )
      ],
    );
  }

  Widget _buildListItem(index) {
    final deckTitle = _decks.keys.elementAt(index);
    final cards = _decks[deckTitle];

    return Card(
      child: ListTile(
          title: Text(deckTitle),
          trailing: Text('${cards?.length ?? 0}'),
          onTap: () => _navigateToReview(deckTitle, cards!)),
    );
  }

  _navigateToReview(String deckTitle, List<ReviewModel> cards) {
    final url = '/${deckTitle.toLowerCase().replaceAll('lesson ', 'review_')}';

    Navigator.pushNamed(
      context,
      url,
      arguments: {
        'title': deckTitle,
        'cards': cards,
      },
    );
  }

  Future<QuerySnapshot> _getNextReview() async {
    final currentUser = context.read<GoogleSignInProvider>().user;

    return await FirebaseFirestore.instance
        .collectionGroup('cards')
        .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('nextReview', descending: false)
        .limit(1)
        .get();
  }
}
