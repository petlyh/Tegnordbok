import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:tegnordbok/widgets/loader.dart";
import "package:video_player/video_player.dart";

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
            child: GestureDetector(
                onTap: () => controller.value.isPlaying
                    ? controller.pause()
                    : controller.play(),
                child: VideoPlayer(controller)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SpeedWidget(controller.setPlaybackSpeed),
          ),
        ],
      ),
    );
  }
}

final speedProvider = StateProvider.autoDispose((_) => 1.0);

class SpeedWidget extends ConsumerWidget {
  const SpeedWidget(this.onChanged, {super.key});

  final void Function(double speed) onChanged;

  static const speedValues = [0.25, 0.5, 1.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(speedProvider);

    return SegmentedButton(
        style: const ButtonStyle(
          padding:
              MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
        ),
        segments: speedValues
            .map((value) =>
                ButtonSegment(value: value, label: Text("${value}x")))
            .toList(),
        selected: {speed},
        onSelectionChanged: (selected) {
          final value = selected.first;
          ref.read(speedProvider.notifier).state = value;
          onChanged(value);
        });
  }
}
