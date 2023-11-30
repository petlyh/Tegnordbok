import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/widgets/loader.dart';
import 'package:video_player/video_player.dart';

final videoControllerProvider = FutureProvider.autoDispose
    .family((ref, Future<String> Function() getUrl) async {
  final url = await getUrl();
  final controller = VideoPlayerController.networkUrl(Uri.parse(url));
  await controller.initialize();
  await controller.setLooping(true);
  controller.play();
  return controller;
});

class PlayerWidget extends ConsumerWidget {
  const PlayerWidget(this.getUrl, {super.key});

  final Future<String> Function() getUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref.watch(videoControllerProvider(getUrl));

    return RiverpodLoaderWidget(
      onRetry: () => ref.refresh(videoControllerProvider(getUrl)),
      asyncValue: videoController,
      handler: (controller) => Column(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ],
      ),
    );
  }
}
