// lib/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const _apiKey = 'api_key';
  late final GenerativeModel _model;

  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // ← This must match the pub.dev example exactly:
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
    // welcome
    _messages.add(_Message(
      text: "Hello! I'm Aura Care's assistant powered by Gemini AI. How can I help?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      // ← Notice generateContent takes a list of Content objects
      final resp = await _model.generateContent([Content.text(text)]);  //  [oai_citation:0‡Dart packages](https://pub.dev/packages/google_generative_ai/versions/0.4.5)
      final reply = resp.text?.trim() ?? 'Sorry, no response.';
      setState(() {
        _isTyping = false;
        _messages.add(_Message(text: reply, isUser: false, timestamp: DateTime.now()));
      });
      _scrollToBottom();
    } catch (e, stack) {
      debugPrint('Chat send error: $e\n$stack');
      setState(() {
        _isTyping = false;
        _messages.add(_Message(
          text: "Oops! I couldn't reach the AI: ${e.toString()}",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('h:mm a');
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Virtual Companion'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                return Align(
                  alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                        m.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color:
                              m.isUser ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          m.text,
                          style: TextStyle(
                            color: m.isUser ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          timeFmt.format(m.timestamp),
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text('Typing…', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isTyping ? null : _sendMessage,
                  icon: const Icon(Icons.send, color: Color(0xFF3B82F6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  _Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
