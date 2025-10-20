import 'package:flutter/material.dart';

class ProviderScreen extends StatelessWidget {
  static const route = '/provider';
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider')),
      body: const Center(
        child: Text('Provider: publish a spot (POC placeholder)'),
      ),
    );
  }
}
