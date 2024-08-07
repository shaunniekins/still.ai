import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Welcome to Still.ai ("Still" or the "App"). This document outlines the terms and conditions ("Terms") governing your use of the App. By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of these Terms, you may not access or use the App.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Use of the App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            MarkdownBody(
              data: '''
* You must be 18 years of age or older to use the App.
* You are solely responsible for your use of the App and all content you submit.
* You agree not to use the App for any illegal or unauthorized purpose.
* You agree not to transmit through the App any content that is unlawful, harmful, threatening, abusive, harassing, defamatory, obscene, hateful, or racially or ethnically offensive.
* You agree not to interfere with or disrupt the servers or networks connected to the App.
* Still reserves the right to terminate your access to the App for any reason, at any time, without notice.
              ''',
            ),
            SizedBox(height: 16),
            Text(
              '3. Disclaimer of Warranties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'The App is provided "as is" and "as available" without warranty of any kind, express or implied. Still disclaims all warranties, including but not limited to, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement. Still does not warrant that the App will be uninterrupted, error-free, or virus-free.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Limitation of Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Still shall not be liable for any damages arising out of or related to your use of the App, including but not limited to, direct, indirect, incidental, consequential, punitive, or special damages.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Intellectual Property',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'The App and all content contained therein, including but not limited to text, graphics, logos, images, and software, are the property of Still or its licensors and are protected by copyright and other intellectual property laws.',
            ),
            SizedBox(height: 16),
            Text(
              '6. Governing Law',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'These Terms shall be governed by and construed in accordance with the laws of the Philippines without regard to its conflict of law provisions.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Entire Agreement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'These Terms constitute the entire agreement between you and Still regarding your use of the App.',
            ),
          ],
        ),
      ),
    );
  }
}
