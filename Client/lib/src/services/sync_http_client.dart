import 'package:http/http.dart' as http;

class SyncHttpClient {
  static Future<String> getChangelogData() async {
    Map<String, String> headers = {
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36",
      "Accept-Language": "en-US,en;q=0.9"
    };
    String changeLogUrl =
        "https://raw.githubusercontent.com/Helmssyss/SyncMagnet/main/CHANGELOG.md";
    http.Response response = await http.get(
      Uri.parse(changeLogUrl),
      headers: headers,
    );

    return response.body;
  }
}
