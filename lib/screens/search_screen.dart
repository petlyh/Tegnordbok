import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/fetch.dart';
import 'package:tegnordbok/models.dart';
import 'package:tegnordbok/screens/player_screen.dart';
import 'package:tegnordbok/screens/settings_screen.dart';
import 'package:tegnordbok/widgets/loader.dart';
import 'package:text_search/text_search.dart';

import 'navigation.dart';

final searchControllerProvider = Provider((_) => TextEditingController());
final searchFocusProvider = Provider((_) => FocusNode());
final queryProvider = StateProvider((_) => "");

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.read(searchControllerProvider);
    final searchFocusNode = ref.read(searchFocusProvider);

    void onChange(text) => ref.read(queryProvider.notifier).state = text;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          onChanged: onChange,
          autofocus: false,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
              hintText: "Søk...",
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchFocusNode.requestFocus();
                  searchController.clear();
                  onChange("");
                },
                tooltip: "Tøm",
              )),
        ),
        actions: [
          IconButton(
            onPressed: pushScreen(context, const SettingsScreen()),
            icon: const Icon(Icons.settings),
            tooltip: "Innstillinger",
          ),
        ],
      ),
      body: const LoaderWidget(
        onLoad: fetchAllWords,
        handler: WordListWidget.new,
      ),
    );
  }
}

final wordListScrollControllerProvider = Provider((_) => ScrollController());

class WordListWidget extends ConsumerWidget {
  const WordListWidget(this.words, {super.key});

  final List<Word> words;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final results = _search(query, words);

    final scrollController = ref.read(wordListScrollControllerProvider);

    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: results.length,
      itemBuilder: (_, index) => WordItem(word: results[index]),
    );
  }
}

class WordItem extends StatelessWidget {
  const WordItem({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word.word),
      onTap: pushScreen(context, PlayerScreen(word)),
    );
  }
}

List<Word> _search(String query, List<Word> words) {
  if (query.trim().isEmpty) {
    return words;
  }

  final textSearchItems = words
      .map((word) => TextSearchItem.fromTerms(word, word.word.split(" ")))
      .toList();

  return TextSearch(textSearchItems).fastSearch(query, matchThreshold: 0.4);
}
