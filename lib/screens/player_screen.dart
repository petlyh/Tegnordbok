import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/models.dart';
import 'package:tegnordbok/widgets/loader.dart';
import 'package:video_player/video_player.dart';

final videoControllerProvider =
    FutureProvider.autoDispose.family((ref, Word word) async {
  final url = await word.stream.getUrl();
  final controller = VideoPlayerController.networkUrl(Uri.parse(url));
  await controller.initialize();
  await controller.setLooping(true);
  controller.play();
  return controller;
});

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen(this.word, {super.key});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref.watch(videoControllerProvider(word));

    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
      ),
      body: RiverpodLoaderWidget(
        onRetry: () => ref.refresh(videoControllerProvider(word)),
        asyncValue: videoController,
        handler: (controller) => Column(
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            if (word.comment != null) Text(word.comment!),
          ],
        ),
      ),
    );
  }
}
