// lib/home_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';

import 'chat_screen.dart'; // ← updated import
import 'critical_condition_screen.dart';
import 'mandala_screen.dart';
import 'my_collection_screen.dart';
import 'results_screen.dart';
import 'screening_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.85,
  );
  Timer? _timer;

  // 50 healing quotes
  final List<String> _quotes = [
    '“You are stronger than you think.”',
    '“Every day is a new beginning.”',
    // … rest of your 50 quotes …
    '“Joy is on the other side of fear.”',
  ];

  // 5 background images for the quote cards
  final List<String> _bgImages = [
    'assets/cimg1.jpg',
    'assets/cimg2.jpg',
    'assets/cimg3.jpg',
    'assets/cimg4.jpg',
    'assets/cimg5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyCollectionScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
      // case 0 is Home: do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting + SOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hello there,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  OutlinedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CriticalConditionScreen(),
                          ),
                        ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'SOS',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 8),

              // Quote carousel
              if (_quotes.isEmpty)
                SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      'No quotes available',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (ctx, i) {
                      final quote = _quotes[i % _quotes.length];
                      final bg = _bgImages[i % _bgImages.length];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(bg),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              quote,
                              style: const TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 16),

              // Feature cards
              Expanded(
                child: Column(
                  children: [
                    FeatureImageCard(
                      imagePath: 'assets/bing1.png',
                      title: 'Results',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const ResultsScreen(
                                    //anxietyScore: 0,
                                    //depressionScore: 0,
                                  ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    FeatureImageCard(
                      imagePath: 'assets/bing3.png',
                      title: 'Draw',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MandalaScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    FeatureImageCard(
                      imagePath: 'assets/bing2.png',
                      title: 'Screening',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScreeningScreen(),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Colors.white24, thickness: 1),
          BottomNavigationBar(
            currentIndex: 0,
            backgroundColor: const Color(0xFF0F172A),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            onTap: _onNavTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.collections_bookmark_outlined),
                label: 'My Collection',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                label: 'Companion',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A large feature card with a background image + dark overlay
class FeatureImageCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const FeatureImageCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
