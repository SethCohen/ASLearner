import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/utils/data_provider.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final cards = context.watch<DataProvider>().dictionary;

    // TODO add search bar
    // TODO restyle with better loading indicator and better card design
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: cards.length + 1,
          itemBuilder: (context, index) {
            if (index == cards.length) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return Card(
              child: ListTile(
                title: Text(cards[index].title),
                subtitle: Text(cards[index].instructions),
                leading: Image.network(cards[index].image),
              ),
            );
          }),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      context.read<DataProvider>().loadMoreDictionary();
    }
  }
}
