// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'second_screen.dart'; // your SignUpScreen
import 'settings_screen.dart'; // updated SettingsScreen with onThemeChanged callback

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatefulWidget {
  const MentalHealthApp({super.key});

  @override
  State<MentalHealthApp> createState() => _MentalHealthAppState();
}

class _MentalHealthAppState extends State<MentalHealthApp> {
  bool _isDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/signup': (_) => const SignUpScreen(),
        '/settings':
            (_) => SettingsScreen(
              onThemeChanged: (isDark) => setState(() => _isDarkTheme = isDark),
            ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Removed the empty AppBar entirely
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/meditation.jpg',
                  width: screenWidth * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),

            // Main Title
            const Text(
              'Your mental health is important',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Description
            const Text(
              'We are here to help you understand your mental health and provide you with the resources you need to feel better.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),

            // Cards: two side-by-side, then one full-width
            Column(
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: InfoCard(
                        icon: Icons.chat_bubble_outline,
                        title: 'Virtual Companion',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: InfoCard(
                        icon: Icons.calendar_today_outlined,
                        title: 'Clinical Recommendations',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const InfoCard(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Access to Clinical Experts',
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),

            // Get Started button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 26, 68, 135),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const InfoCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
