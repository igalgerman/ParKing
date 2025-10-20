import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_spacing.dart';
import '../../core/design/design_constants.dart' as design;

/// Home screen - Modern branded entry point
/// 
/// Features vibrant gradients, glassmorphism, and contemporary design
class HomeScreen extends StatelessWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background with spotlight
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: parkingHeroGradient,
              ),
            ),
            child: CustomPaint(
              painter: _SpotlightPainter(),
              size: Size.infinite,
            ),
          ),

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Hero section
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(spaceLarge),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated icon with glow
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: design.animationSlow,
                            curve: design.curveSmooth,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: 0.8 + (value * 0.2),
                                child: Opacity(
                                  opacity: value,
                                  child: Container(
                                    padding: const EdgeInsets.all(spaceMedium),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          blurRadius: 40,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_parking_rounded,
                                      size: design.iconXLarge,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: spaceMedium),
                          
                          // App name with shadow
                          Text(
                            'ParKing',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: design.weightBlack,
                              letterSpacing: -1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: spaceSmall),
                          
                          // Tagline
                          Text(
                            'Modern Parking Made Simple',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: design.weightMedium,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content section with glass cards
                SliverPadding(
                  padding: const EdgeInsets.all(spaceLarge),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Welcome section with subtle glass effect
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spaceMedium,
                          vertical: spaceLarge,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Welcome Back! 👋',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                    fontWeight: design.weightBold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: spaceSmall),
                                Text(
                                  'Choose your role to get started',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                fontWeight: design.weightBold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: spaceSmall),
                            Text(
                              'Choose your role to get started',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: spaceLarge),

                      // Provider card with gradient
                      _ModernRoleCard(
                        key: const Key('provider_btn'),
                        icon: Icons.share_location_rounded,
                        title: 'I\'m a Provider',
                        subtitle: 'Share your spot & earn rewards',
                        gradient: const LinearGradient(
                          colors: [parkingPrimary, parkingPrimaryDark],
                        ),
                        onTap: () => Navigator.of(context).pushNamed('/provider'),
                      ),
                      const SizedBox(height: spaceMedium),

                      // Seeker card with gradient
                      _ModernRoleCard(
                        key: const Key('seeker_btn'),
                        icon: Icons.search_rounded,
                        title: 'I\'m a Seeker',
                        subtitle: 'Find perfect parking instantly',
                        gradient: const LinearGradient(
                          colors: [parkingSecondary, parkingSecondaryDark],
                        ),
                        onTap: () => Navigator.of(context).pushNamed('/seeker'),
                      ),

                      const SizedBox(height: spaceXLarge),

                      // Modern footer with glass effect
                      ClipRRect(
                        borderRadius: BorderRadius.circular(design.radiusLarge),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(spaceMedium),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(design.radiusLarge),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: design.iconSmall,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                const SizedBox(width: spaceSmall),
                                Text(
                                  'Powered by Innovation',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: design.weightMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: spaceMedium),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern role card with gradient and glassmorphism
class _ModernRoleCard extends StatefulWidget {
  const _ModernRoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  State<_ModernRoleCard> createState() => _ModernRoleCardState();
}

class _ModernRoleCardState extends State<_ModernRoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: design.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: design.curveSnappy),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(design.radiusLarge),
            boxShadow: design.primaryShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(design.radiusLarge),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                padding: const EdgeInsets.all(spaceLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(design.radiusLarge),
                ),
                child: Row(
                  children: [
                    // Icon with glow
                    Container(
                      padding: const EdgeInsets.all(spaceMedium),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(design.radiusMedium),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: design.iconLarge,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: spaceMedium),
                    
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: design.weightBold,
                            ),
                          ),
                          const SizedBox(height: spaceSmall),
                          Text(
                            widget.subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrow with animation hint
                    Container(
                      padding: const EdgeInsets.all(spaceSmall),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: design.iconMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for spotlight effect
class _SpotlightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, -0.8),
        radius: 1.2,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
