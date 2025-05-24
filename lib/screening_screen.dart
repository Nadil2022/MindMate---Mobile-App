import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'results_screen.dart'; // Your results screen file

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({super.key});

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  // Question texts (first 7 = GAD-7, next 9 = PHQ-9)
  static const _questions = <String>[
    // GAD-7
    'Feeling nervous, anxious, or on edge',
    'Not being able to stop or control worrying',
    'Worrying too much about different things',
    'Trouble relaxing',
    'Being so restless that it is hard to sit still',
    'Becoming easily annoyed or irritable',
    'Feeling afraid, as if something awful might happen',
    // PHQ-9
    'Little interest or pleasure in doing things',
    'Feeling down, depressed, or hopeless',
    'Trouble falling or staying asleep, or sleeping too much',
    'Feeling tired or having little energy',
    'Poor appetite or overeating',
    'Feeling bad about yourself or that you are a failure or have let yourself or your family down',
    'Trouble concentrating on things, such as reading the newspaper or watching television',
    'Moving or speaking so slowly that other people could have noticed, or the opposite – being so fidgety or restless that you have been moving around a lot more than usual',
    'Thoughts that you would be better off dead, or of hurting yourself',
  ];

  static const _options = <String>[
    'Not at all',
    'Several days',
    'More than half the days',
    'Nearly every day',
  ];

  final List<int?> _answers = List<int?>.filled(_questions.length, null);
  int _anxietyScore = 0;
  int _depressionScore = 0;

  void _submit() async {
    if (_answers.any((a) => a == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    _anxietyScore = _answers.sublist(0, 7).fold(0, (sum, ans) => sum + (ans!));
    _depressionScore = _answers.sublist(7).fold(0, (sum, ans) => sum + (ans!));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .set({
            'anxiety': _anxietyScore,
            'depression': _depressionScore,
            'results': null,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => ResultsScreen(
                //anxietyScore: _anxietyScore,
                //depressionScore: _depressionScore,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving scores: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Screening Test',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                const Text(
                  'Over the last two weeks, how often have you been bothered by the following?',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < _questions.length; i++) ...[
                  Text(
                    '${i + 1}. ${_questions[i]}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (var opt = 0; opt < _options.length; opt++)
                    _OptionRow(
                      label: _options[opt],
                      isSelected: _answers[i] == opt,
                      onTap: () => setState(() => _answers[i] = opt),
                    ),
                  const SizedBox(height: 20),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 18)),
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

class _OptionRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionRow({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white)),
            ),
            Radio<int>(
              value: 1,
              groupValue: isSelected ? 1 : 0,
              onChanged: (_) => onTap(),
              fillColor: WidgetStateProperty.all(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
