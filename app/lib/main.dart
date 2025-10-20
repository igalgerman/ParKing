import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart'; // Uncomment after Firebase setup
import 'package:app/core/design/app_theme.dart';
import 'package:app/core/design/app_colors.dart';
import 'package:app/core/design/design_constants.dart' as design;
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/screens/provider_screen.dart';
import 'package:app/presentation/screens/seeker_screen.dart';
import 'package:app/presentation/screens/auth/login_screen.dart';
import 'package:app/presentation/screens/auth/register_screen.dart';
// import 'firebase_options.dart'; // Uncomment after running flutterfire configure

/// Main entry point of the ParKing POC application.
/// Initializes Firebase and Riverpod for state management.
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // Uncomment after running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

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
      title: 'ParKing',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        ProviderScreen.route: (_) => const ProviderScreen(),
        SeekerScreen.route: (_) => const SeekerScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
    );
  }
}

/// Splash screen displayed on app launch.
/// Modern animated splash with gradient background and smooth transitions.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _navTimer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: design.animationSlow,
      vsync: this,
    );

    // Fade in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: design.curveSmooth),
      ),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: design.curveBounce),
      ),
    );

    // Pulse animation (continuous)
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _controller.forward();

    // Add repeating pulse effect
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Navigate to Login after delay
    _navTimer = Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: parkingHeroGradient,
              ),
            ),
          ),

          // Radial Gradient Overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  parkingAccent.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Glassmorphic overlay effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.white.withOpacity(0.05),
            ),
          ),

          // Content
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Pulsing Icon
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: design.accentGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: parkingAccent.withOpacity(0.4),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_parking_rounded,
                              size: design.iconHero,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // App Name with gradient
                        ShaderMask(
                          shaderCallback: (bounds) => design.warmGradient
                              .createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Text(
                            'ParKing',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: design.weightBlack,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Tagline
                        Text(
                          'Find Your Perfect Spot',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: design.weightMedium,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Sub-tagline
                        Text(
                          'Innovative Parking Marketplace',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: design.weightRegular,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Loading indicator
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom branding
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Powered by Modern Design',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: design.weightLight,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
