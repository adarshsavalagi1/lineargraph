import 'package:flutter/material.dart';

class TooltipWidget extends StatelessWidget {
  final int selectedHour;
  final double bpmValue;
  final Offset position;

  const TooltipWidget({
    super.key,
    required this.selectedHour,
    required this.bpmValue,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx < 0 ? 0 : position.dx > 300? 300*0.7 : position.dx*0.7,
      top: 0,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BPM: ${bpmValue.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            // const SizedBox(height: 2),
            Text(
              'Time: ${selectedHour % 24}:00',
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
            // Text(
            //   'dx: ${position.dx} dy: ${position.dy}',
            //   style: const TextStyle(color: Colors.black, fontSize: 5),
            // ),
          ],
        ),
      ),
    );
  }
}