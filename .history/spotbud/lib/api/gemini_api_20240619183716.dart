import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiApiService {
  String apiKey = dotenv.env["GEMINIAPI"]!;
  final String apiKey = 'YOUR_API_KEY';
  final String baseUrl = 'https://api.geminiai.com/v1';

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