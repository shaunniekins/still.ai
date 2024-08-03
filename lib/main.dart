import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatbot.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
    print("Successfully loaded .env file");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'still.ai',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                letterSpacing: BorderSide.strokeAlignOutside),
          ),
        ),
        body: const ChatbotInterface(),
      ),
    );
  }
}
