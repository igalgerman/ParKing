import 'package:flutter/material.dart';

class SeekerScreen extends StatelessWidget {
  static const route = '/seeker';
  const SeekerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seeker')),
      body: const Center(
        child: Text('Seeker: search nearby (POC placeholder)'),
      ),
    );
  }
}
