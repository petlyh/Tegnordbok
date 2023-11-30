import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/models.dart';
import 'package:tegnordbok/screens/example_screen.dart';
import 'package:tegnordbok/screens/navigation.dart';
import 'package:tegnordbok/widgets/player.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen(this.word, {super.key});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PlayerWidget(word.stream.getUrl),
            if (word.comment != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(word.comment!),
                )),
              ),
            if (word.examples.isNotEmpty)
              ...word.examples
                  .asMap()
                  .entries
                  .map((entry) => ElevatedButton(
                      onPressed: pushScreen(
                          context, ExampleScreen(entry.value, entry.key + 1)),
                      child: Text("Eksempel ${entry.key + 1}")))
                  .toList(),
          ],
        ),
      ),
    );
  }
}
