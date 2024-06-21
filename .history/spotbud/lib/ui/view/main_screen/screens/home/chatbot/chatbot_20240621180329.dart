import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotbud/api/chat_service.dart';
import 'package:spotbud/api/gemini_api.dart';
import 'package:spotbud/ui/widgets/formattertext.dart';
import 'package:spotbud/api/chatmodel.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GeminiApiService _apiService = GeminiApiService();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _apiService.initialize();
    // Initialize ChatService with the current user's ID
    _chatService =
        ChatService(userId: getCurrentUserId()); // Replace with actual user ID
    _loadMessages();
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print('No user is currently signed in');
      return 'anonymous';
    }
  }

  void _loadMessages() {
    _chatService.getMessages().listen((messages) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages.cast<ChatMessage>());
      });
      _scrollToBottom();
    });
  }

  void _sendMessage(String message) async {
    final chatMessage = ChatMessage(text: message, isUser: true);
    setState(() {
      _messages.add(chatMessage);
      _isBotTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Save user message to Firestore
    await _chatService.saveMessage(chatMessage);

    try {
      String reply = await _apiService.sendMessage(message);
      final botMessage = ChatMessage(text: reply, isUser: false);
      setState(() {
        _isBotTyping = false;
        _messages.add(botMessage);
      });
      // Save bot message to Firestore
      await _chatService.saveMessage(botMessage);
      _scrollToBottom();
    } catch (e) {
      final errorMessage =
          ChatMessage(text: 'Error: Failed to send message', isUser: false);
      setState(() {
        _isBotTyping = false;
        _messages.add(errorMessage);
      });
      // Save error message to Firestore
      await _chatService.saveMessage(errorMessage);
      _scrollToBottom();
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(child: Icon(Icons.fitness_center)),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text('Typing'),
                SizedBox(width: 5),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.background.withOpacity(0.2),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isBotTyping) {
                    return _buildTypingIndicator();
                  }
                  return _messages[index];
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                      onSubmitted: (String message) {
                        if (message.trim().isNotEmpty) {
                          _sendMessage(message.trim());
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () {
                      String message = _textController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
                    child: Icon(Icons.send),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final ChatMessageModel model;

  const ChatMessage({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            model.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!model.isUser) CircleAvatar(child: Icon(Icons.fitness_center)),
          SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: model.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FormattedText(
                text: model.text,
                style: TextStyle(
                  color: model.isUser
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          if (model.isUser) CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }
}
