import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:still/widgets/chat_message.dart';
import 'package:still/widgets/typing_indicator.dart';

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

  bool _isTyping = false;

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
7. Maintain a friendly and approachable tone in all responses.
8. Use techniques from Cognitive Behavioral Therapy (CBT), Dialectical Behavioral Therapy (DBT), and Acceptance and Commitment Therapy (ACT) without explicitly naming them.

Remember, you're here to offer support and information about mental health, not to replace professional care.'''),
      Content.model([
        TextPart(
            "Understood. I'm here to provide support and information related to mental health, emotions, and well-being. I'll focus our conversations on these topics and offer empathetic responses. How can I assist you with your mental health or emotional concerns today?"),
      ]),
    ];

    setState(() {
      _messages.add(const ChatMessage(
        text: "What's up? How are you doing?",
        isUser: false,
      ));
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add(ChatMessage(
          text: userMessage,
          isUser: true,
        ));
        _isTyping = true;
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
        var responseText = response.text ??
            'I apologize, but I couldn\'t generate a response. Can we try rephrasing your question?';

        responseText = responseText.trimRight();

        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: responseText,
            isUser: false,
          ));
          _chatHistory.add(Content.model([TextPart(responseText)]));
        });
      } catch (e) {
        print('Error generating response: $e');
        setState(() {
          _isTyping = false;
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
    return PopScope(
        canPop: false,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(45.0),
              child: AppBar(
                centerTitle: true,
                title: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text(
                    'still.ai',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
              ),
            ),
            body: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: _messages.isEmpty
                          ? const Center(
                              child: Text(
                                "What's on your mind?",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _messages.length + (_isTyping ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < _messages.length) {
                                  return _messages[index];
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TypingIndicator(),
                                  );
                                }
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
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
                              style: const TextStyle(fontSize: 14.0),
                              decoration: const InputDecoration(
                                hintText: "Share your thoughts",
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 0.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
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
                                  : const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
