import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'ChartPainter.dart';
import 'Tooltip.dart';
import 'Yaxispainter.dart';



class StockChart extends StatefulWidget {
  const StockChart({super.key});

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  int _selectedHour = 0; // Initial selected hour
  Offset _touchPosition = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              SizedBox(
                height: 270,
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 0, 8, 16),
                            height: 200,
                            child: CustomPaint(
                              painter: ChartPainter(selectedHour: _selectedHour),
                              size: ui.Size.infinite,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10), // Adjust padding between y-axis and chart
                        SizedBox(
                          width: 40, // Width for y-axis labels
                          child: CustomPaint(
                            painter: YAxisPainter(),
                            size: const ui.Size(
                                40, 200), // Adjusted size for y-axis painter
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_touchPosition.dy < 200)
                TooltipWidget(
                  selectedHour: _selectedHour >= ChartPainter.dataPoints.length
                      ? ChartPainter.dataPoints.length
                      : _selectedHour,
                  bpmValue: _selectedHour >= ChartPainter.dataPoints.length
                      ? ChartPainter.dataPoints.last
                      : ChartPainter.dataPoints[_selectedHour],
                  position: _touchPosition,
                ),
              GestureDetector(
                onTapDown: (details) {
                  _handleTouch(details.localPosition);
                },
                onHorizontalDragUpdate: (details) {
                  _handleTouch(details.localPosition);
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTouch(Offset position) {
    setState(() {
      _touchPosition = position;
      _selectedHour = _getHourIndex(position);
    });
  }

  int _getHourIndex(Offset position) {
    const hoursInDay = 24;
    const double stepX = 360 / hoursInDay; // Adjusted width for the chart
    return (position.dx / stepX).round().clamp(0, hoursInDay - 1);
  }
}
