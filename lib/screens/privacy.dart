import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Still respects the privacy of its users. This Privacy Policy explains how we collect, use, and disclose information about you when you use the App.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'We may collect the following information about you:',
            ),
            MarkdownBody(
              data: '''
* Personal information you provide directly, such as your name and email address (optional).
* Information about your use of the App, such as the content of your chats and interactions with the chatbot.
              ''',
            ),
            SizedBox(height: 16),
            Text(
              '3. How We Use Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'We may use your information to:',
            ),
            MarkdownBody(
              data: '''
* Provide and improve the App.
* Analyze your use of the App for research purposes.
* Communicate with you about the App.
              ''',
            ),
            SizedBox(height: 16),
            Text(
              '4. Disclosure of Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'We will not share your personal information with third parties without your consent, except:',
            ),
            MarkdownBody(
              data: '''
* As required by law or to comply with a legal process. 
* To protect the rights, property, or safety of Still or others.
              ''',
            ),
            SizedBox(height: 16),
            Text(
              '5. Your Choices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'You have choices about the information you provide to us. You are not required to provide any personal information to use the App.',
            ),
            SizedBox(height: 16),
            Text(
              '6. Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
                'We take reasonable steps to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no internet or electronic storage system is completely secure.'),
            SizedBox(height: 16),
            Text(
              '7. Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at shaunniel02@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}
