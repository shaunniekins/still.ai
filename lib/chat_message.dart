import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text('AI', style: TextStyle(color: Colors.white)),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(text),
          ),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('You', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
