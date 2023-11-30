import 'dart:io';

import 'package:tegnordbok/models.dart';
import 'package:tegnordbok/sources.dart';
import 'package:xml/xml.dart';
import "package:http/http.dart" as http;

Future<List<Word>> fetchAllWords() async {
  final tegnordbokWords = await _fetchWords(TegnordbokSource());
  final tegnwikiWords = await _fetchWords(TegnwikiSource());
  final allWords = tegnordbokWords + tegnwikiWords;

  allWords.sort((a, b) => a.word.compareTo(b.word));
  return allWords;
}

Future<List<Word>> _fetchWords(Source source) async {
  final data = await _fetchXml(source.dataUrl);
  return data.findAllElements("leksem").map((element) {
    final word = element.getAttribute("visningsord")!;
    final stream = source.streamFromFilename(element.getAttribute("filnavn")!);

    final commentAttribute = element.getAttribute("kommetarviss");
    final comment = commentAttribute != null && commentAttribute.isNotEmpty
        ? commentAttribute
        : null;

    final examples = element
        .findAllElements("kontekstform")
        .map((e) => Example(
            example: e.getAttribute("kommentar")!,
            stream: source.streamFromFilename(e.getAttribute("filnavn")!)))
        .toList();

    return Word(
        word: word, stream: stream, comment: comment, examples: examples);
  }).toList();
}

Future<XmlDocument> _fetchXml(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw const HttpException("Status code not 200 OK");
  }

  return XmlDocument.parse(response.body);
}
