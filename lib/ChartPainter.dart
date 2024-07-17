import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final int selectedHour;

  ChartPainter({required this.selectedHour});

  static final List<double> dataPoints = [0,
    24,
    91,
    10,
    11,
    12,
    20,
    74,
    8,
    13,
    15,
    86,
    122,
    5,
    20,
    74,
    8,
    13,
    14,
    15,134
  ];
  static final List<double> shadedPoints = [
    24,
    91,
    10,
    11,
    12,
    20,
    74,
    54,
    13,
    14,
    15,
    56,
    17,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final shadedPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final dashedLinePaint = Paint()
      ..color = Colors.grey.shade900
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridLinePaint = Paint()
      ..color = Colors.grey.shade500.withOpacity(0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint1 = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5
      ..style = PaintingStyle.fill;

    final dotPaint2 = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final double stepX = (size.width - 40) / 24; // 24 represents hours
    final double minY = dataPoints.reduce(min);
    const double rangeY = 120;

    // Draw x-axis labels
    const xLabels = ['12 AM', '6 AM', '12 PM', '6 PM', '12 AM'];
    for (int i = 0; i < 5; i++) {
      final xLabel = xLabels[i];
      textPainter.text = TextSpan(
        text: xLabel,
        style: const TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      final x = i * stepX * 6;
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, size.height + 4));
    }

    // Draw x-axis dots
    final List<Offset> Xpoints1 = List.generate(24, (i) {
      if (i % 6 == 0) {
        return Offset(0, size.height);
      }
      final x = i * stepX;
      return Offset(x, size.height);
    });
    canvas.drawPoints(PointMode.points, Xpoints1, dotPaint1);

    final List<Offset> Xpoints2 = List.generate(24, (i) {
      if (i % 6 != 0) {
        return Offset(0, size.height);
      }
      final x = i * stepX;
      return Offset(x, size.height);
    });
    canvas.drawPoints(PointMode.points, Xpoints2, dotPaint2);

    // Draw y-axis dashed lines at specific positions
    final List<double> yPositions = [
      18,
      85,
      150
    ]; // Y-axis positions where dashed lines will be drawn

    const double dashWidth = 5; // Length of each dash
    const double dashSpace = 8; // Space between dashes

    for (double y in yPositions) {
      double startX = 0; // Starting x-coordinate of the dashed line
      double endX = size.width; // Ending x-coordinate of the dashed line
      double lineY = size.height - y; // Y-coordinate of the dashed line

      while (startX < size.width) {
        double dashEndX = startX + dashWidth;
        if (dashEndX > endX) {
          dashEndX = endX;
        }
        canvas.drawLine(
          Offset(startX, lineY),
          Offset(dashEndX, lineY),
          gridLinePaint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    // Draw line graph
    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * stepX;
      final y = size.height - ((dataPoints[i] - minY) / rangeY * size.height);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset((p1.dx + p2.dx) / 2, p1.dy);
      final controlPoint2 = Offset((p1.dx + p2.dx) / 2, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, p2.dx, p2.dy);
    }
    canvas.drawPath(path, paint);

    // Draw shaded area under the line graph
    final shadedPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      shadedPath.lineTo(points[i].dx, points[i].dy);
    }
    final minYShaded = shadedPoints.reduce(min);
    for (int i = shadedPoints.length - 1; i >= 0; i--) {
      final x = i * stepX;
      final y =
          size.height - ((shadedPoints[i] - minYShaded) / rangeY * size.height);
      shadedPath.lineTo(x, y);
    }
    shadedPath.close();
    canvas.drawPath(shadedPath, shadedPaint);

    // Draw dashed vertical line at selected hour
    if (selectedHour >= 0 && selectedHour < points.length) {
      const double dashHeight = 5.0;
      const double dashSpace = 3.0;
      double startY = 0.0;
      final dx = points[selectedHour].dx;

      while (startY < size.height) {
        canvas.drawLine(
          Offset(dx, startY),
          Offset(dx, startY + dashHeight),
          dashedLinePaint,
        );
        startY += dashHeight + dashSpace;
      }
    } else if (selectedHour >= points.length) {
      final dx = points.last.dx;
      const double dashHeight = 5.0;
      const double dashSpace = 3.0;
      double startY = 0.0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(dx, startY),
          Offset(dx, startY + dashHeight),
          dashedLinePaint,
        );
        startY += dashHeight + dashSpace;
      }
    }

    // Draw tooltip if selected hour is the last hour
    if (selectedHour == dataPoints.length - 1) {
      // Find the smallest and largest values in dataPoints
      final minValue = dataPoints.reduce(min);
      final maxValue = dataPoints.reduce(max);

      // Find their corresponding points
      final minIndex = dataPoints.indexOf(minValue);
      final maxIndex = dataPoints.indexOf(maxValue);
      final minX = minIndex * stepX;
      final maxX = maxIndex * stepX;
      final minYGraph = dataPoints.reduce(min);
      shadedPoints.reduce(max);
      final minText = '$minValue';
      final maxText = '$maxValue';

      // Draw tooltip for the minimum value
      final textSpan = TextSpan(
        text: minText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,backgroundColor: Colors.white
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textX = minX + 10;
      final textY = size.height -
          ((minValue - minYGraph) / rangeY * size.height) -
          textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));

      // Draw tooltip for the maximum value
      final textSpanMax = TextSpan(
        text: maxText,
        style: const TextStyle(
            color: Colors.black, fontSize: 12, backgroundColor: Colors.white),
      );
      final textPainterMax = TextPainter(
        text: textSpanMax,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainterMax.layout();
      final textXMax = maxX-30;
      final textYMax = size.height  - (maxValue  - minYGraph) / rangeY * size.height - textPainterMax.height / 2;
      print(textYMax);
      textPainterMax.paint(canvas, Offset(textXMax, textYMax));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
