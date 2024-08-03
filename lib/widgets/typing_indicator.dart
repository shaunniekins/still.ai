import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            int dotCount = (_controller.value * 3).floor() + 1;
            return Text(
              '.' * dotCount,
              style: const TextStyle(
                  fontSize: 25.0), 
            );
          },
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
