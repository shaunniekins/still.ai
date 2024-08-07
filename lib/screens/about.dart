import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Still.ai: Your Supportive Companion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Still.ai is an AI-powered chatbot designed to offer support and companionship. We’re here to listen, provide information, and offer coping strategies. Our goal is to create a safe space where you can openly discuss your feelings and thoughts.",
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Important: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Still.ai is not a professional mental health service. While we strive to provide helpful and supportive interactions, our chatbot is not a replacement for therapy or counseling from a qualified mental health professional. If you are experiencing a mental health crisis, please contact a crisis hotline or seek professional help immediately.',
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'We encourage you to use Still.ai as a tool to complement professional care, but it should never be considered a substitute.',
            ),
            SizedBox(height: 16),
            Text(
              'Remember, you are not alone, and there are people who can help.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
