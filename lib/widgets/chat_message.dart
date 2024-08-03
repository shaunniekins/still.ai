import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:still/utils/theme_provider.dart';

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isLightTheme = themeProvider.themeMode == ThemeMode.light ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.light);
        final bgColor = isUser
            ? Colors.teal
            : (isLightTheme ? Colors.teal[50] : Colors.grey[800]);
        final fgColor = isUser
            ? Colors.white
            : (isLightTheme ? Colors.black : Colors.white);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MarkdownBody(
                  data: text,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: fgColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
