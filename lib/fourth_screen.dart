// lib/fourth_screen.dart

import 'package:flutter/material.dart';
import 'package:mental_health_app/chat_screen.dart';
import 'fifth_screen.dart';           // ChatScreen
import 'my_collection_screen.dart';  // MyCollectionScreen
import 'screening_screen.dart';      // ScreeningScreen

class MooditudeScreen extends StatelessWidget {
  const MooditudeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar with back button & title
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MindMate',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Heading
                const Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Subheading
                const Text(
                  'Select an option',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),

                // AI Chatbot → ChatScreen
                _OptionItem(
                  label: 'AI Chatbot',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Virtual Companion (placeholder)
                _OptionItem(
                  label: 'Virtual Companion',
                  onTap: () {
                    // TODO: navigate to your Virtual Companion screen
                  },
                ),
                const SizedBox(height: 16),

                // My Collection → MyCollectionScreen
                _OptionItem(
                  label: 'My Collection',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyCollectionScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Screening Test → ScreeningScreen
                _OptionItem(
                  label: 'Screening Test',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScreeningScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OptionItem({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}