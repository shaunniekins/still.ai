import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  final ValueNotifier<bool> loginNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal,
              Colors.deepPurple,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', height: 150),
                    ],
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'By clicking Log in, you agree with our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, '/terms'),
                        ),
                        const TextSpan(text: ' and that you have read our '),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, '/privacy'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/main');
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
