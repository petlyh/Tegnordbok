import "package:tegnordbok/models.dart";

sealed class Source {
  String get dataUrl;
  VideoStream streamFromFilename(String filename);
}

class TegnordbokSource implements Source {
  @override
  final String dataUrl =
      "https://www.minetegn.no/tegnordbok/xml/tegnordbok.php";

  @override
  VideoStream streamFromFilename(String filename) =>
      UrlStream("https://www.minetegn.no/Tegnordbok-HTML/video_/$filename.mp4");
}

class TegnwikiSource implements Source {
  @override
  final String dataUrl =
      "https://www.minetegn.no/tegnordbok/tegnwiki/xml/data.php";

  @override
  VideoStream streamFromFilename(String filename) {
    if (filename.startsWith("https://")) {
      return UrlStream(filename);
    }

    return YoutubeStream(filename);
  }
}
