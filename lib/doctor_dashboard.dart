// lib/doctor_dashboard.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final Map<String, TextEditingController> _notesControllers = {};

  @override
  void dispose() {
    for (final controller in _notesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<List<UserReport>> _fetchReports() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      _notesControllers[id] = TextEditingController(text: data['notes'] ?? '');

      return UserReport(
        id: id,
        name: data['name'] ?? 'Unknown',
        phone: data['phone'] ?? 'Unknown',
        anxietyScore: data['anxiety'] ?? 0,
        depressionScore: data['depression'] ?? 0,
        anxietyRecs: (data['anxietyreco'] as String?)?.split(';') ?? [],
        depressionRecs: (data['depressionreco'] as String?)?.split(';') ?? [],
        notes: data['notes'] ?? '',
      );
    }).toList();
  }

  Future<void> _updateNotes(String id, String newNote) async {
    await FirebaseFirestore.instance.collection('patients').doc(id).update({
      'notes': newNote,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notes updated')));
  }

  Future<void> _updateResults(String id, String newResults) async {
    await FirebaseFirestore.instance.collection('patients').doc(id).update({
      'results': newResults,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Results updated')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<UserReport>>(
        future: _fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reports available',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final reports = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final report = reports[index];
              final controller = _notesControllers[report.id]!;

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      report.phone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anxiety Score: ${report.anxietyScore}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Depression Score: ${report.depressionScore}',
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Anxiety Recommendations:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (var rec in report.anxietyRecs)
                      if (rec.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $rec',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),

                    const SizedBox(height: 8),
                    const Text(
                      'Depression Recommendations:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (var rec in report.depressionRecs)
                      if (rec.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $rec',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),

                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add your notes…',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _updateNotes(report.id, controller.text);
                              _updateResults(report.id, 'Certified');
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text('Certify'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _updateResults(report.id, 'Declined');
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text('Decline'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserReport {
  final String id;
  final String name;
  final String phone;
  final int anxietyScore;
  final int depressionScore;
  final List<String> anxietyRecs;
  final List<String> depressionRecs;
  final String notes;

  UserReport({
    required this.id,
    required this.name,
    required this.phone,
    required this.anxietyScore,
    required this.depressionScore,
    required this.anxietyRecs,
    required this.depressionRecs,
    required this.notes,
  });
}
