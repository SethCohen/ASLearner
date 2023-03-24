import 'package:asl/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Map<String, List<ReviewModel>> _decks = {};

  @override
  void initState() {
    super.initState();
    context.read<DataProvider>().loadReviews();
    _decks = context.read<DataProvider>().reviews;
  }

  @override
  Widget build(BuildContext context) {
    if (_decks.isEmpty) {
      return const Center(child: Text('Nothing left to review! Good work!'));
    }

    // TODO "All Cards" review page

    return ListView.builder(
        itemCount: _decks.length,
        itemBuilder: (context, index) => _buildListItem(index));
  }

  Widget _buildListItem(index) {
    final deckTitle = _decks.keys.elementAt(index);
    final cards = _decks[deckTitle];

    return Card(
      child: ListTile(
          title: Text(deckTitle),
          trailing: Text('${cards?.length ?? 0}'),
          onTap: () => _navigateToReview(deckTitle, cards)),
    );
  }

  _navigateToReview(String deckTitle, List<ReviewModel>? cards) {
    Navigator.pushNamed(
      context,
      '/${deckTitle.toLowerCase().replaceAll(' ', '_')}',
      arguments: {
        'cards': cards,
      },
    );
  }
}
