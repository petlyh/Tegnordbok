import 'package:flutter_test/flutter_test.dart';
import 'package:tegnordbok/fetch.dart';

void main() {
  test("word", () async {
    final allWords = await fetchAllWords();
    final word = allWords.first;
    expect(word.word, "0");
  });
}
