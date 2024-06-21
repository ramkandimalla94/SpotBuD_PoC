import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class GeminiApiService {
  late String apiKey;
  final String baseUrl = 'https://api.geminiai.com/v1';

  Future<void> initialize() async {
    await dotenv.load();
    apiKey = dotenv.env['GEMINIAPI']!;
  }

  Future<String> sendMessage(String message) async {
    final url = '$baseUrl/message';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({"message": message}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to send message: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}
