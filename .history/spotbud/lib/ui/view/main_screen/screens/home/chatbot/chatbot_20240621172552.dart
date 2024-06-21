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
  late ChatService _chatService;
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _apiService.initialize();
    String userId = getCurrentUserId();
    _chatService = ChatService(userId: userId);
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
    });
  }

  void _sendMessage(String message) async {
    final newMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.insert(0, newMessage);
      _isBotTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    await _chatService.saveMessage(newMessage);

    try {
      String reply = await _apiService.sendMessage(message);
      final botMessage = ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _isBotTyping = false;
        _messages.insert(0, botMessage);
      });
      await _chatService.saveMessage(botMessage);
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isBotTyping = false;
        _messages.insert(
            0,
            ChatMessage(
              text: 'Error: Failed to send message',
              isUser: false,
              timestamp: DateTime.now(),
            ));
      });
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
                reverse: true,
                controller: _scrollController,
                itemCount: _messages.length + (_isBotTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0 && _isBotTyping) {
                    return _buildTypingIndicator();
                  }
                  final messageIndex = _isBotTyping ? index - 1 : index;
                  return _buildMessageWidget(_messages[messageIndex]);
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
                          color: Theme.of(context).colorScheme.primary),
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

  Widget _buildMessageWidget(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) CircleAvatar(child: Icon(Icons.fitness_center)),
          SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormattedText(
                    text: message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser
                          ? Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.7)
                          : Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          if (message.isUser) CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage(
      {Key? key,
      required this.text,
      required this.isUser,
      required DateTime timestamp})
      : super(key: key);

  @override
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
