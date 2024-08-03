import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:still/models/mood.dart';
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
          _isTyping = false; // Hide typing indicator
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

  final List<Mood> moods = [
    Mood(mood: 'Angry', icon: Icons.sentiment_very_dissatisfied),
    Mood(mood: 'Anxious', icon: Icons.sentiment_dissatisfied),
    Mood(mood: 'Disgusted', icon: Icons.sentiment_very_dissatisfied),
    Mood(mood: 'Embarrassed', icon: Icons.sentiment_neutral),
    Mood(mood: 'Bored', icon: Icons.sentiment_neutral),
    Mood(mood: 'Envious', icon: Icons.sentiment_dissatisfied),
    Mood(mood: 'Excited', icon: Icons.sentiment_very_satisfied),
    Mood(mood: 'Fearful', icon: Icons.sentiment_dissatisfied),
    Mood(mood: 'Happy', icon: Icons.sentiment_very_satisfied),
    Mood(mood: 'Sad', icon: Icons.sentiment_dissatisfied),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        hintText: "Say something",
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
                                _focusNode.unfocus();
                                _showMoodDialog(context);
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showMoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('What are you feeling?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: moods.map((mood) {
                return ListTile(
                  leading: Icon(mood.icon),
                  title: Text(mood.mood),
                  onTap: () {
                    Navigator.of(context).pop();
                    _sendMoodMessage(mood.mood);
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendMoodMessage(String mood) {
    String message = "I'm currently feeling $mood. ";

    // Customize the message based on the mood
    switch (mood.toLowerCase()) {
      case 'angry':
        message += "I'm having a hard time managing my anger right now.";
        break;
      case 'anxious':
        message += "I'm feeling worried and uneasy about things.";
        break;
      case 'disgusted':
        message +=
            "Something is really bothering me and making me feel repulsed.";
        break;
      case 'embarrassed':
        message +=
            "I'm feeling self-conscious and uncomfortable about something that happened.";
        break;
      case 'bored':
        message += "I'm feeling uninspired and lacking motivation.";
        break;
      case 'envious':
        message += "I'm struggling with feelings of jealousy towards others.";
        break;
      case 'excited':
        message +=
            "I'm feeling really enthusiastic and energetic about something.";
        break;
      case 'fearful':
        message +=
            "I'm experiencing a sense of fear or apprehension about something.";
        break;
      case 'happy':
        message += "I'm in a good mood and feeling positive about things.";
        break;
      case 'sad':
        message += "I'm feeling down and experiencing a sense of sorrow.";
        break;
      default:
        message += "Can you help me explore these feelings?";
    }

    _controller.text = message;
    _scrollToBottom();
    _sendMessage();
  }
}
