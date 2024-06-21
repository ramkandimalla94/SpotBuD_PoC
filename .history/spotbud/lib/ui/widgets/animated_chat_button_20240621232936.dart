import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/main_screen/screens/home/chatbot/chatbot.dart';
import 'package:spotbud/ui/widgets/assets.dart';

class AnimatedChatButton extends StatefulWidget {
  const AnimatedChatButton({Key? key}) : super(key: key);

  @override
  _AnimatedChatButtonState createState() => _AnimatedChatButtonState();
}

class _AnimatedChatButtonState extends State<AnimatedChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _popUpAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _popUpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
          bottom: 80,
          right: 0,
          child: FadeTransition(
            opacity: _popUpAnimation,
            child: const SpeechBubble(
              message:
                  "I'm your fitness assistant!\nClick here to interact with me.",
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    Get.to(ChatScreen());
                  },
                  backgroundColor: Colors.blue.shade400,
                  elevation: 8.0,
                  tooltip: 'Chat',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        AppAssets.chatbot,
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String message;

  const SpeechBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }
}
