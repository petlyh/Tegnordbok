import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/models.dart';
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
      body: Column(
        children: [
          PlayerWidget(word.stream.getUrl),
          if (word.comment != null) Text(word.comment!),
        ],
      ),
    );
  }
}
