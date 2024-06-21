// In package:spotbud/api/chatmodel.dart
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage(
      {required this.text, required this.isUser, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toUtc().millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      isUser: map['isUser'],
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(map['timestamp'], isUtc: true)
              .toLocal(),
    );
  }
}
