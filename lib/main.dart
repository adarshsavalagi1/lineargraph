import 'package:flutter/material.dart';
import 'StockChart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stock Chart'),
        ),
        body: const Center(
          child: StockChart(),
        ),
      ),
    );
  }
}
