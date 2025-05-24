import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'critical_condition_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int? anxietyScore;
  int? depressionScore;
  String? results;
  String? note; //1
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScoresFromFirestore();
  }

  Future<void> _loadScoresFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        anxietyScore = data['anxiety'] ?? 0;
        depressionScore = data['depression'] ?? 0;
        results = data['results'];
        note = data['notes'] ?? 'No notes available'; //2
        isLoading = false;
      });
    } else {
      // No data for user
      setState(() {
        anxietyScore = 0;
        depressionScore = 0;
        isLoading = false;
      });
    }
  }

  String get _anxietySeverity {
    final score = anxietyScore ?? 0;
    if (score <= 4) return 'Minimal anxiety';
    if ((score > 4) && (score <= 9)) return 'Mild anxiety';
    if ((score > 9) && (score <= 14)) return 'Moderate anxiety';
    return 'Severe anxiety';
  }

  String get _depressionSeverity {
    final score = depressionScore ?? 0;
    if (score <= 4) return 'Minimal depression';
    if (score <= 9) return 'Mild depression';
    if (score <= 14) return 'Moderate depression';
    if (score <= 19) return 'Moderately severe depression';
    return 'Severe depression';
  }

  List<String> _getAnxietyRecommendations(int score) {
    if (score <= 4) {
      return [
        'Daily 5–10 min of guided mindfulness or deep breathing',
        '20 min daily walks or gentle yoga sessions',
        'Evening gratitude journaling (3 positives)',
        'Two meaningful social conversations weekly',
        'Consistent 7–9 hr sleep schedule',
      ];
    } else if (score <= 9) {
      return [
        '15 min guided meditation or progressive muscle relaxation, 3×/week',
        'Use a daily planner app for structured routines',
        'Moderate aerobic exercise (30 min × 3 times/week)',
        'Monthly anxiety support groups (online/in-person)',
        'Limit caffeine & reduce sugar intake',
      ];
    } else if (score <= 14) {
      return [
        'Weekly CBT sessions',
        '5-4-3-2-1 grounding exercises',
        'Weekly biofeedback training via apps/devices',
        'Fortnightly follow-ups with a mental health professional',
        'Emergency anxiety crisis management plan',
      ];
    } else {
      return [
        'Urgent psychiatric evaluation & intensive therapy',
        'Immediate app-based crisis line connection',
        'Daily therapeutic engagements (CBT/exposure)',
        'Weekly psychiatric medication reviews',
        '24/7 in-app clinical support access',
      ];
    }
  }

  List<String> _getDepressionRecommendations(int score) {
    if (score <= 4) {
      return [
        'Daily 15 min moderate exercise (walking, jogging)',
        'Weekly pleasurable activity scheduling',
        'Weekly social connections with friends/family',
        'Consistent bedtime + relaxation before sleep',
        'Daily 10 min mindfulness meditation',
      ];
    } else if (score <= 9) {
      return [
        'Weekly therapist-guided CBT activities',
        'Aerobic exercise 20–30 min, 4×/week',
        'Daily mood & activity journaling',
        'Monthly peer-led support groups',
        'Nutrition plan rich in omega-3s and vitamins',
      ];
    } else if (score <= 14) {
      return [
        'Weekly structured psychotherapy (CBT/interpersonal)',
        'Daily planned behavioral activation (hobbies/exercise)',
        'Psychiatric evaluation for medication consideration',
        'Structured weekly support from your social network',
        'Daily emotional check-ins via the app',
      ];
    } else if (score <= 19) {
      return [
        'Immediate psychiatrist review for medication support',
        'Twice-weekly intensive psychotherapy',
        'Therapist-supported daily self-care routine',
        'Close medication adherence monitoring',
        'Accessible emergency action plan in-app',
      ];
    } else {
      return [
        'Assessment for psychiatric hospitalization',
        'Immediate pharmacological + psychotherapeutic care',
        'Daily clinical monitoring via telehealth/in-person',
        '24/7 crisis support availability',
        'Coordinated care team engagement',
      ];
    }
  }

  bool get _needsSOS {
    return (anxietyScore ?? 0) >= 10 && (depressionScore ?? 0) >= 10;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final anxietyRecs = _getAnxietyRecommendations(anxietyScore ?? 0);
    final depressionRecs = _getDepressionRecommendations(depressionScore ?? 0);

    return Scaffold(
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
                Row(
                  children: [
                    const Text(
                      'Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    results == null
                        ? const SizedBox(
                          width: 120, // Approximate width of the button
                          height: 40, // Approximate height of the button
                        )
                        : ElevatedButton.icon(
                          onPressed: () {
                            // Your onPressed logic here
                          },
                          icon: Icon(
                            results == 'Declined' ? Icons.close : Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            results == 'Declined' ? 'Declined' : 'Certified',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                results == 'Declined'
                                    ? Colors.red
                                    : Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: ResultCard(
                          label: 'Anxiety',
                          severity: _anxietySeverity,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ResultCard(
                          label: 'Depression',
                          severity: _depressionSeverity,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Based on your screening results, we recommend:',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Anxiety Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                for (var rec in anxietyRecs) _RecRow(text: rec),
                const SizedBox(height: 24),
                const Text(
                  'Depression Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                for (var rec in depressionRecs) _RecRow(text: rec),
                const SizedBox(height: 32),
                //3
                //const SizedBox(height: 24),
                const Text(
                  'Note:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  note ?? 'No notes available',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                //3
                const SizedBox(height: 32),
                if (_needsSOS)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CriticalConditionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Connect to SOS Service',
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

class ResultCard extends StatelessWidget {
  final String label;
  final String severity;

  const ResultCard({super.key, required this.label, required this.severity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            severity,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecRow extends StatelessWidget {
  final String text;
  const _RecRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}