import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app/core/design/app_colors.dart';
import 'package:app/core/design/app_spacing.dart';
import 'package:app/core/design/design_constants.dart' as design;

/// Provider Screen - Publish Parking Spots
/// Modern UI with gradient FAB and glassmorphic cards
class ProviderScreen extends StatefulWidget {
  static const route = '/provider';
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  bool _isPublishing = false;
  bool _hasActiveSpot = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: design.animationNormal,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _publishSpot() {
    setState(() {
      _isPublishing = true;
    });

    // Simulate GPS capture and publishing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isPublishing = false;
        _hasActiveSpot = true;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Spot published successfully!'),
            ],
          ),
          backgroundColor: parkingPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(design.radiusMedium),
          ),
        ),
      );
    });
  }

  void _cancelSpot() {
    setState(() {
      _hasActiveSpot = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 12),
            Text('Spot cancelled'),
          ],
        ),
        backgroundColor: parkingSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Provider'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
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

          // Content
          SafeArea(
            child: _hasActiveSpot ? _buildActiveSpot() : _buildEmptyState(),
          ),
        ],
      ),
      floatingActionButton: _buildModernFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spaceLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large Icon with gradient
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: design.accentGradient,
                boxShadow: design.accentShadow,
              ),
              child: const Icon(
                Icons.add_location_alt_outlined,
                size: design.iconXXLarge,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              'No Active Spot',
              style: TextStyle(
                fontSize: 28,
                fontWeight: design.weightBold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Tap the button below to publish\nyour parking spot',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: design.weightRegular,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSpot() {
    return ListView(
      padding: const EdgeInsets.all(spaceMedium),
      children: [
        const SizedBox(height: 20),

        // Active Spot Card
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: design.warmGradient,
                      borderRadius: BorderRadius.circular(design.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: design.weightBold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.timer_outlined,
                    size: design.iconSmall,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '28 min left',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: design.weightMedium,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Location Info
              Text(
                'Your Parking Spot',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: design.weightBold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              _buildInfoRow(
                Icons.location_on_outlined,
                'GPS Accuracy',
                '5.2m',
              ),

              const SizedBox(height: 8),

              _buildInfoRow(
                Icons.access_time_outlined,
                'Published',
                '2 minutes ago',
              ),

              const SizedBox(height: 20),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _cancelSpot,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel Spot'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(design.radiusMedium),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Stats Card
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: design.weightSemiBold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('Spots Published', '1', Icons.check_circle_outline),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  Expanded(
                    child: _buildStatItem('Total Views', '12', Icons.visibility_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(design.radiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(design.radiusLarge),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: design.iconSmall,
          color: Colors.white.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: design.weightRegular,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: design.weightSemiBold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: design.iconMedium,
          color: Colors.white.withOpacity(0.9),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: design.weightBold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: design.weightRegular,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildModernFAB() {
    if (_hasActiveSpot) return const SizedBox.shrink();

    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: spaceMedium),
      decoration: BoxDecoration(
        gradient: design.accentGradient,
        borderRadius: BorderRadius.circular(design.radiusXLarge),
        boxShadow: design.accentShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isPublishing ? null : _publishSpot,
          borderRadius: BorderRadius.circular(design.radiusXLarge),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isPublishing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(
                    Icons.add_location_alt_rounded,
                    size: design.iconLarge,
                    color: Colors.white,
                  ),
                const SizedBox(width: 12),
                Text(
                  _isPublishing ? 'Publishing...' : 'Publish Parking Spot',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: design.weightBold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
