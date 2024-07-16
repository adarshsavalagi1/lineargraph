import 'package:flutter/material.dart';

class YAxisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    // Define the height allocated for each label segment
    final double labelHeight = size.height / 3;

    // Draw y-axis labels in increasing order
    for (int i = 0; i < 3; i++) {
      final yLabel = '${20 + i * 60} bpm';

      // Set the text to be painted
      textPainter.text = TextSpan(
        text: yLabel,
        style: const TextStyle(color: Colors.black, fontSize: 10),
      );

      // Layout the text
      textPainter.layout();

      // Calculate the y position starting from the bottom
      final y = size.height - (labelHeight * i) - labelHeight / 2 - textPainter.height / 2;

      // Paint the text on the canvas
      textPainter.paint(canvas, Offset(size.width - textPainter.width - 4, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
