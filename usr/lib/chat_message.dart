import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {required this.text, required this.animationController, super.key});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    const String sender = 'You';
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const CircleAvatar(child: Text(sender)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sender, style: Theme.of(context).textTheme.titleMedium),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
