import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app/core/design/app_colors.dart';
import 'package:app/core/design/app_spacing.dart';
import 'package:app/core/design/design_constants.dart' as design;

/// Seeker Screen - Search and Purchase Parking Spots
/// Modern UI with glassmorphic search and gradient spot cards
class SeekerScreen extends StatefulWidget {
  static const route = '/seeker';
  const SeekerScreen({super.key});

  @override
  State<SeekerScreen> createState() => _SeekerScreenState();
}

class _SeekerScreenState extends State<SeekerScreen> {
  bool _isSearching = false;
  final List<ParkingSpotMock> _spots = [];

  @override
  void initState() {
    super.initState();
    _searchSpots();
  }

  void _searchSpots() {
    setState(() {
      _isSearching = true;
    });

    // Simulate search
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _spots.addAll([
          ParkingSpotMock('Downtown Plaza', '0.3 km', '5 min ago', 4.5),
          ParkingSpotMock('City Center', '0.5 km', '12 min ago', 4.8),
          ParkingSpotMock('Main Street', '0.8 km', '3 min ago', 4.2),
          ParkingSpotMock('Shopping Mall', '1.2 km', '8 min ago', 4.6),
        ]);
      });
    });
  }

  void _refreshSpots() {
    setState(() {
      _spots.clear();
    });
    _searchSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Seeker'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              // Show filters
            },
          ),
        ],
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
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: parkingAccentGradient,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Search Bar
                _buildModernSearchBar(),

                const SizedBox(height: 16),

                // Results Count
                if (_spots.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: spaceMedium),
                    child: Row(
                      children: [
                        Text(
                          '${_spots.length} spots nearby',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: design.weightSemiBold,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.info_outline,
                          size: design.iconSmall,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Spot List
                Expanded(
                  child: _isSearching
                      ? _buildLoadingState()
                      : _spots.isEmpty
                          ? _buildEmptyState()
                          : _buildSpotsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spaceMedium),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.radiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(design.radiusLarge),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white.withOpacity(0.9),
                  size: design.iconMedium,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search parking near you...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: design.warmGradient,
                    borderRadius: BorderRadius.circular(design.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: design.iconMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Searching nearby spots...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: design.weightMedium,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spaceLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: design.iconXXLarge,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No spots found nearby',
              style: TextStyle(
                fontSize: 22,
                fontWeight: design.weightBold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search radius\nor check back later',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: design.weightRegular,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotsList() {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshSpots();
      },
      color: parkingPrimary,
      backgroundColor: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: spaceMedium),
        itemCount: _spots.length,
        itemBuilder: (context, index) {
          return _buildSpotCard(_spots[index], index);
        },
      ),
    );
  }

  Widget _buildSpotCard(ParkingSpotMock spot, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: design.curveBounce,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(design.radiusLarge),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(design.radiusLarge),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: design.warmGradient,
                          borderRadius: BorderRadius.circular(design.radiusMedium),
                        ),
                        child: const Icon(
                          Icons.local_parking_rounded,
                          color: Colors.white,
                          size: design.iconLarge,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spot.location,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: design.weightBold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: design.iconSmall,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  spot.distance,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: design.weightMedium,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.access_time,
                                  size: design.iconSmall,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  spot.publishedAgo,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: design.weightMedium,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(design.radiusSmall),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: design.iconSmall,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          spot.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: design.weightSemiBold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified_rounded,
                          size: design.iconSmall,
                          color: parkingSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: design.weightMedium,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: design.accentGradient,
                            borderRadius: BorderRadius.circular(design.radiusSmall),
                          ),
                          child: const Text(
                            'Get Spot',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: design.weightBold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock data model for parking spots
class ParkingSpotMock {
  final String location;
  final String distance;
  final String publishedAgo;
  final double rating;

  ParkingSpotMock(this.location, this.distance, this.publishedAgo, this.rating);
}
