import 'package:flutter/material.dart';
import 'presentation/pages/snake_page.dart';

void main() {
  runApp(const SnakeApp());
}

class SnakeApp extends StatelessWidget {
  const SnakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Snake',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SnakePage(),
    );
  }
}
