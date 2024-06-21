// In your chat_service.dart file

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/api/chatmodel.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  ChatService({required this.userId});

  Future<void> saveMessage(ChatMessageModel message) async {
    await _firestore
        .collection('data')
        .doc(userId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<ChatMessageModel>> getMessages() {
    return _firestore
        .collection('data')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromMap(doc.data()))
            .toList());
  }
}
