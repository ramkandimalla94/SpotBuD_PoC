import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  late GenerativeModel _model;
  late ChatSession _chat;

  Future<void> initialize() async {
    await dotenv.load();
    final apiKey = dotenv.env['GEMINIAPI'];
    if (apiKey == null) {
      throw Exception('No GEMINIAPI key found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-pro', // or 'gemini-1.5-flash' depending on your needs
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100),
    );

    _chat = _model.startChat(history: [
      Content.text(
          'You are a fitness and gym assistant. Help users with workout advice and gym-related queries.'),
      Content.model([
        TextPart(
            'Understood. I am here to help with fitness and gym-related questions. How can I assist you today?')
      ])
    ]);
  }

  Future<String> sendMessage(String message) async {
    try {
      var content = Content.text(message);
      var response = await _chat.sendMessage(content);
      return response.text ?? 'No response generated';
    } catch (e) {
      print('Error sending message: $e');
      return 'Error: Failed to get response from AI';
    }
  }
}
