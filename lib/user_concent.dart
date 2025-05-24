import 'package:flutter/material.dart';
import 'package:mental_health_app/third_screen.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark background
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "By using this app, you agree to the following terms:\n\n"
                "1. This app provides support tools for mental wellness.\n"
                "2. It is not a substitute for professional medical advice.\n"
                "3. Your data is handled securely and will not be shared without your consent.\n"
                "4. Misuse of the platform may result in account restrictions.\n\n"
                "Please ensure you use this app responsibly and contact professionals for any serious concerns.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact & Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'If you have any questions, feel free to reach out to us at support@example.com.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Your logic here (e.g., navigate to another screen, submit form, etc.)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ), // replace ChatScreen with your target screen
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 110, 123, 142),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 55,
                    ),
                    //padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
