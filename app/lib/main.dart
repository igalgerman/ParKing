import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/screens/provider_screen.dart';
import 'package:app/presentation/screens/seeker_screen.dart';

/// Main entry point of the ParKing POC application.
/// Initializes Riverpod for state management.
void main() {
  runApp(
    const ProviderScope(
      child: ParKingApp(),
    ),
  );
}

/// Root widget of the ParKing application.
/// Sets up Material Design 3 theme and navigation.
class ParKingApp extends StatelessWidget {
  const ParKingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParKing POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        ProviderScreen.route: (_) => const ProviderScreen(),
        SeekerScreen.route: (_) => const SeekerScreen(),
      },
    );
  }
}

/// Splash screen displayed on app launch.
/// Shows ParKing branding and tagline.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navTimer;
  @override
  void initState() {
    super.initState();
    // Navigate to Home after a short delay to keep splash visible for tests.
    _navTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_parking,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'ParKing POC',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Peer-to-Peer Parking Marketplace',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
