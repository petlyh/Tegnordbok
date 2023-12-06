import "dart:convert";

import "package:http/http.dart" as http;

class PipedException {
  final String message;
  final String stacktrace;

  const PipedException(this.message, this.stacktrace);
}

class Piped {
  static const mainInstanceUrl = "https://pipedapi.kavin.rocks";

  final String apiUrl;

  const Piped(this.apiUrl);
  static const main = Piped(mainInstanceUrl);

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(Uri.parse("$apiUrl$path"));

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data["error"] != null) {
      throw PipedException(data["message"] as String, data["error"] as String);
    }

    return data;
  }

  Future<List<dynamic>> getVideoStreams(String id) async {
    final response = await get("/streams/$id");
    return response["videoStreams"] as List<dynamic>;
  }

  Future<String> getStreamUrl(String id) async {
    final streams = await getVideoStreams(id);
    return streams.first["url"] as String;
  }
}
