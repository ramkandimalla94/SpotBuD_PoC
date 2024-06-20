import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiApiService {
  late String apiKey;
  final String baseUrl = 'https://api.geminiai.com/v1';

  Future<void> initialize() async {
    await dotenv.load();
    apiKey = dotenv.env['GEMINIAPI']!;
  }

  Future<String> sendMessage(String message) async {
    final url = '$baseUrl/message';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: '{"message": "$message"}',
    );

    if (response.statusCode == 200) {
      // Parse the response and return the bot's reply
      // You may need to adjust this based on the Gemini API response format
      return response.body;
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }
}
