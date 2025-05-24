// lib/critical_condition_screen.dart

import 'package:flutter/material.dart';
import 'package:mental_health_app/chat_screen.dart';

import 'fifth_screen.dart';

class CriticalConditionScreen extends StatelessWidget {
  const CriticalConditionScreen({super.key});

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
          'Critical Condition',
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
                // Header
                const Text(
                  'What can we help with?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // “I’m feeling suicidal” card
                _HelpCard(
                  imageAsset: 'assets/suicidal.png', // <-- add this asset
                  title: "I'm feeling suicidal",
                  subtitle: "If you're in immediate danger, call 1926 now.",
                  onTap: () {
                    // You could auto-dial here if you like
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dialing 1926…')),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // “I need to talk to someone” card
                _HelpCard(
                  imageAsset:
                      'assets/talk_to_someone.png', // <-- add this asset
                  title: "I need to talk to someone",
                  subtitle: "We're here for you. Connect with a therapist now.",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                ),

                const Spacer(),

                // Contact 1926 button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dialing 1926…')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Contact 1926',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A reusable card with a background image, gradient overlay, and text
class _HelpCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // gradient overlay
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
