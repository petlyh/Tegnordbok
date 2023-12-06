import "package:flutter_test/flutter_test.dart";
import "package:tegnordbok/piped.dart";

void main() {
  test("OXbn6kVS4C0", () async {
    expect(await Piped.main.getStreamUrl("OXbn6kVS4C0"),
        contains("https://pipedproxy"));
  });
}
