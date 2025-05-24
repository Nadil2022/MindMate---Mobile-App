// lib/mandala_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';

class MandalaScreen extends StatefulWidget {
  const MandalaScreen({Key? key}) : super(key: key);

  @override
  State<MandalaScreen> createState() => _MandalaScreenState();
}

class _MandalaScreenState extends State<MandalaScreen> {
  // All the strokes drawn so far
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  // Number of mirrored segments
  static const int _segments = 12;

  // Currently selected color (with opacity baked in)
  Color _selectedColor = Colors.pinkAccent.withOpacity(0.7);

  // Preset palette
  final List<Color> _palette = [
    Colors.pinkAccent.withOpacity(0.7),
    Colors.blueAccent.withOpacity(0.7),
    Colors.greenAccent.withOpacity(0.7),
    Colors.orangeAccent.withOpacity(0.7),
    Colors.yellowAccent.withOpacity(0.7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text(
          'Mandala Art',
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
              children: [
                // Drawing area
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final center = Offset(
                        constraints.maxWidth / 2,
                        constraints.maxHeight / 2,
                      );
                      return GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            _currentStroke = [];
                            _strokes.add(_currentStroke);
                            _currentStroke
                                .add(details.localPosition - center);
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _currentStroke
                                .add(details.localPosition - center);
                          });
                        },
                        onPanEnd: (_) => _currentStroke = [],
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _MandalaPainter(
                            strokes: _strokes,
                            segments: _segments,
                            center: center,
                            color: _selectedColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Color picker row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _palette.map((color) {
                    final isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: isSelected ? 40 : 32,
                        height: isSelected ? 40 : 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),

      // Clear button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _strokes.clear();
          });
        },
        tooltip: 'Clear',
      ),
    );
  }
}

/// Draws each stroke mirrored around the center with the chosen color
class _MandalaPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final int segments;
  final Offset center;
  final Color color;

  _MandalaPainter({
    required this.strokes,
    required this.segments,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Move origin to center
    canvas.translate(center.dx, center.dy);

    for (var stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke[0].dx, stroke[0].dy);
      for (var pt in stroke.skip(1)) path.lineTo(pt.dx, pt.dy);

      // Draw rotated & mirrored copies
      for (int i = 0; i < segments; i++) {
        final angle = (2 * pi / segments) * i;
        canvas.save();
        canvas.rotate(angle);
        canvas.drawPath(path, paint);
        canvas.scale(1, -1);
        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MandalaPainter old) =>
      old.strokes != strokes || old.color != color;
}