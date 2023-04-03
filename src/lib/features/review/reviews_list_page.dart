import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/utils/data_provider.dart';
import 'review_model.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    _decks = context.watch<DataProvider>().reviews;

    if (_decks.isEmpty) {
      return const Center(child: Text('Nothing left to review! Good work!'));
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
}
