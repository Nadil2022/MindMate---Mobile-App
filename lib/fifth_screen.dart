// lib/fifth_screen.dart

import 'package:flutter/material.dart';

class ChatScreen1 extends StatefulWidget {
  const ChatScreen1({super.key});

  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar with “Chat” title and a right arrow
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              // You can hook this to collapse/close chat if you like
            },
          ),
        ],
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
                // Sub‐heading
                const Text(
                  "You are not alone. We're here to help.",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 24),

                // Crisis Text Line header
                Row(
                  children: [
                    // Replace with your actual asset or network image
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/crisis_avatar.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Crisis Text Line',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "We're here 24/7, ready to listen and support you.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Elara’s chat bubble
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Replace with your actual asset or network image
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/elara_avatar.png'),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Hello! I'm here to help you with your mental health "
                          "assessment. Let's get started. What is your gender?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Radio options
                _buildOption('Male'),
                const SizedBox(height: 12),
                _buildOption('Female'),
                const SizedBox(height: 12),
                _buildOption('Non-binary'),

                const Spacer(),

                // Back / Next buttons
                Row(
                  children: [
                    // Back
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E293B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Next
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _selectedGender == null
                                ? null
                                : () {
                                  // Navigate to screen six, for instance:
                                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const SixthScreen()));
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds one of the three radio options
  Widget _buildOption(String label) {
    final isSelected = _selectedGender == label;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Radio<String>(
              value: label,
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
              fillColor: WidgetStateProperty.all(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}