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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                          color: Colors.white.withOpacity(0.5), width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
