// In chatmodel.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageModel(
      {required this.text, required this.isUser, DateTime? timestamp})
      : this.timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      text: map['text'],
      isUser: map['isUser'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
