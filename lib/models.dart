import "package:tegnordbok/piped.dart";

class Word {
  final String word;
  final VideoStream stream;

  final String? comment;
  final List<Example> examples;

  const Word(
      {required this.word,
      required this.stream,
      this.comment,
      this.examples = const []});
}

class Example {
  final String example;
  final VideoStream stream;

  const Example({required this.example, required this.stream});
}

sealed class VideoStream {
  Future<String> getUrl();
}

class UrlStream implements VideoStream {
  final String url;

  const UrlStream(this.url);

  @override
  Future<String> getUrl() async => url;
}

class YoutubeStream implements VideoStream {
  final String id;

  const YoutubeStream(this.id);

  @override
  Future<String> getUrl() => Piped.main.getStreamUrl(id);
}
