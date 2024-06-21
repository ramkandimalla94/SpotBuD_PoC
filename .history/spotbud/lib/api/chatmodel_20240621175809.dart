// In chatmodel.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/formattertext.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : this.timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      isUser: map['isUser'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) CircleAvatar(child: Icon(Icons.fitness_center)),
          SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FormattedText(
                text: text,
                style: TextStyle(
                  color: isUser
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          if (isUser) CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }
}
