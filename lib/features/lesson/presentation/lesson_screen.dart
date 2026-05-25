import 'package:flutter/material.dart';

// Шелл-экран урока: обёртка для флоу Theory → Practice → Additional
class LessonScreen extends StatelessWidget {
  final Widget child;

  const LessonScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
