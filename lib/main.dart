import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:still/screens/about.dart';
import 'package:still/screens/chatbot_interface.dart';
import 'package:still/screens/intro.dart';
import 'package:still/screens/privacy.dart';
import 'package:still/screens/settings.dart';
import 'package:still/screens/terms.dart';
import 'package:still/utils/theme_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          ),
          themeMode: themeProvider.themeMode,
          home: const HomePage(),
          routes: {
            '/intro': (context) => IntroPage(),
            '/main': (context) => const ChatbotInterface(),
            '/settings': (context) => const SettingsScreen(),
            '/terms': (context) => const TermsScreen(),
            '/privacy': (context) => const PrivacyScreen(),
            '/about': (context) => const AboutScreen(),
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }

    setState(() {
      _isFirstTime = isFirstTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isFirstTime ? IntroPage() : const ChatbotInterface(),
    );
  }
}
