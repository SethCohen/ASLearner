import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: _getAvailableReviews(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, List<ReviewModel>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            _decks = snapshot.data!;

            if (_decks.isEmpty) {
              return _buildNoReviewsAvailable();
            }

            return Column(
              children: [
                _buildReviewAll(_decks),
                Expanded(
                  child: ListView.builder(
                      itemCount: _decks.length,
                      itemBuilder: (context, index) => _buildListItem(index)),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildNoReviewsAvailable() {
    return FutureBuilder(
        future: _getNextAvailableReview(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return _buildLessonWarning();
          }
          return _buildNextAvailableReviewWarning(snapshot);
        });
  }

  Widget _buildNextAvailableReviewWarning(snapshot) {
    final card = snapshot.data!.docs.first.data() as Map<String, dynamic>;
    final formattedDate = DateFormat.yMMMd()
        .add_jm()
        .format((card['nextReview'] as Timestamp).toDate());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('No reviews available. Please come back again later.'),
        Text('Next review: $formattedDate'),
      ],
    );
  }

  Widget _buildLessonWarning() {
    return const Align(
        alignment: Alignment.topCenter,
        child: Text(
            'No reviews available. Please do a lesson first to get a review.'));
  }

  Widget _buildReviewAll(Map<String, List<ReviewModel>> decks) {
    final List<ReviewModel> allCards =
        decks.values.expand((element) => element).toList();

    return Card(
        child: ListTile(
            title: const Text('Review All'),
            trailing: Text('${allCards.length}'),
            onTap: () => _navigateToReview('Review All', allCards)));
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

  void _navigateToReview(String deckTitle, List<ReviewModel> cards) {
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

  Stream<Map<String, List<ReviewModel>>> _getAvailableReviews() {
    return FirebaseFirestore.instance
        .collectionGroup('cards')
        .where('nextReview', isLessThan: DateTime.now())
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((querySnapshot) {
      final reviewModelList = querySnapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.id, doc.data());
      }).toList();

      return groupBy(reviewModelList, (ReviewModel review) => review.deckTitle);
    });
  }

  Future<QuerySnapshot> _getNextAvailableReview() async {
    final currentUser = context.read<GoogleSignInProvider>().user;

    return await FirebaseFirestore.instance
        .collectionGroup('cards')
        .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('nextReview', descending: false)
        .limit(1)
        .get();
  }
}
