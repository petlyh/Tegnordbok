import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/fetch.dart';
import 'package:tegnordbok/models.dart';
import 'package:tegnordbok/screens/player_screen.dart';
import 'package:tegnordbok/widgets/loader.dart';

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
      ),
      body: const LoaderWidget(
        onLoad: fetchAllWords,
        handler: WordListWidget.new,
      ),
    );
  }
}

class WordListWidget extends ConsumerWidget {
  const WordListWidget(this.words, {super.key});

  final List<Word> words;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);

    final filteredWords = query.isNotEmpty
        ? words
            .where(
                (word) => word.word.toLowerCase().contains(query.toLowerCase()))
            .toList()
        : words;

    return ListView.builder(
      itemCount: filteredWords.length,
      itemBuilder: (_, index) => WordItem(word: filteredWords[index]),
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
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PlayerScreen(word))),
    );
  }
}
