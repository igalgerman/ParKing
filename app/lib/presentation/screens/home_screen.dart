import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ParKing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('provider_btn'),
              onPressed: () => Navigator.of(context).pushNamed('/provider'),
              child: const Text("I'm a Provider"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              key: const Key('seeker_btn'),
              onPressed: () => Navigator.of(context).pushNamed('/seeker'),
              child: const Text("I'm a Seeker"),
            ),
          ],
        ),
      ),
    );
  }
}
