import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:still/chat_message.dart';

class ChatbotInterface extends StatefulWidget {
  const ChatbotInterface({super.key});

  @override
  _ChatbotInterfaceState createState() => _ChatbotInterfaceState();
}

class _ChatbotInterfaceState extends State<ChatbotInterface> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late GenerativeModel _model;
  List<Content> _chatHistory = [];
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      print('No GEMINI_API_KEY found in .env file');
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );

    _chatHistory = [
      Content.text(
          '''You are a mental health support chatbot. Your responses should focus exclusively on topics related to mood, feelings, emotional well-being, and mental health. 

Rules:
1. Only discuss mental health, emotions, and well-being.
2. Do not engage in conversations about unrelated topics.
3. If asked about something unrelated, gently redirect the conversation back to mental health.
4. Provide empathetic and supportive responses.
5. Encourage seeking professional help when appropriate.
6. Do not diagnose or provide medical advice.

Remember, you're here to offer support and information about mental health, not to replace professional care.'''),
      Content.model([
        TextPart(
            "Understood. I'm here to provide support and information related to mental health, emotions, and well-being. I'll focus our conversations on these topics and offer empathetic responses. How can I assist you with your mental health or emotional concerns today?"),
      ]),
    ];
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add(ChatMessage(
          text: userMessage,
          isUser: true,
        ));
      });

      _chatHistory.add(Content.text(userMessage));
      _controller.clear();
      _scrollToBottom();

      try {
        final response = await _model.generateContent([
          ..._chatHistory,
          Content.text(
              'Remember to focus only on mental health, emotions, and well-being in your response. If the user\'s message is unrelated, gently redirect the conversation back to mental health topics.')
        ]);
        final responseText = response.text ??
            'I apologize, but I couldn\'t generate a response. Can we try rephrasing your question?';

        setState(() {
          _messages.add(ChatMessage(
            text: responseText,
            isUser: false,
          ));
          _chatHistory.add(Content.model([TextPart(responseText)]));
        });
      } catch (e) {
        print('Error generating response: $e');
        setState(() {
          _messages.add(const ChatMessage(
            text:
                'I apologize, but I encountered an error. Can we refocus on how you\'re feeling or any mental health concerns you\'d like to discuss?',
            isUser: false,
          ));
        });
      }
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                    onSubmitted: (value) {
                      _focusNode.requestFocus();
                    },
                    onTapAlwaysCalled: true,
                    onTap: _scrollToBottom,
                    onChanged: (_) => _scrollToBottom(),
                    onTapOutside: (_) {
                      _focusNode.unfocus();
                    },
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.teal,
                            onPressed: () {
                              _sendMessage();
                              _focusNode.requestFocus();
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.emoji_emotions),
                            color: Colors.teal,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
