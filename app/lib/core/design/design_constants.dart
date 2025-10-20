/// Modern Design Constants for ParKing
/// 
/// Contemporary visual design tokens including glassmorphism,
/// blur effects, shadows, and modern styling parameters.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

// ============================================================================
// GLASSMORPHISM EFFECTS
// ============================================================================

/// Glassmorphic blur for modern card effects
const double glassBlurStrength = 10.0;
const double glassBlurStrengthHeavy = 20.0;
const double glassBlurStrengthLight = 5.0;

/// Create glassmorphic background filter
ImageFilter get glassBlurFilter => ImageFilter.blur(
      sigmaX: glassBlurStrength,
      sigmaY: glassBlurStrength,
    );

ImageFilter get glassBlurFilterHeavy => ImageFilter.blur(
      sigmaX: glassBlurStrengthHeavy,
      sigmaY: glassBlurStrengthHeavy,
    );

// ============================================================================
// MODERN SHADOWS WITH COLOR TINTS
// ============================================================================

/// Primary shadow with purple tint - for primary buttons and cards
List<BoxShadow> get primaryShadow => [
      BoxShadow(
        color: parkingShadowPrimary,
        blurRadius: 20,
        offset: const Offset(0, 10),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: parkingShadowPrimary.withOpacity(0.1),
        blurRadius: 40,
        offset: const Offset(0, 20),
        spreadRadius: -5,
      ),
    ];

/// Secondary shadow with cyan tint
List<BoxShadow> get secondaryShadow => [
      BoxShadow(
        color: parkingShadowSecondary,
        blurRadius: 20,
        offset: const Offset(0, 10),
        spreadRadius: 0,
      ),
    ];

/// Accent shadow with pink tint
List<BoxShadow> get accentShadow => [
      BoxShadow(
        color: parkingShadowAccent,
        blurRadius: 24,
        offset: const Offset(0, 12),
        spreadRadius: -2,
      ),
    ];

/// Soft neutral shadow for cards
List<BoxShadow> get cardShadow => [
      BoxShadow(
        color: parkingShadowNeutral,
        blurRadius: 16,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: parkingShadowNeutral,
        blurRadius: 32,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
    ];

/// Elevated shadow for floating elements
List<BoxShadow> get elevatedShadow => [
      BoxShadow(
        color: parkingShadowNeutral.withOpacity(0.1),
        blurRadius: 40,
        offset: const Offset(0, 20),
        spreadRadius: -8,
      ),
    ];

// ============================================================================
// MODERN GRADIENTS - Linear & Radial
// ============================================================================

/// Create primary gradient
LinearGradient get primaryGradient => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: parkingHeroGradient,
    );

/// Create accent gradient
LinearGradient get accentGradient => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: parkingAccentGradient,
    );

/// Create warm gradient
LinearGradient get warmGradient => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: parkingWarmGradient,
    );

/// Vertical gradient for backgrounds
LinearGradient get verticalGradient => const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: parkingHeroGradient,
    );

/// Radial gradient for spotlight effects
RadialGradient get spotlightGradient => RadialGradient(
      center: Alignment.topLeft,
      radius: 1.5,
      colors: [
        parkingHeroGradient[0].withOpacity(0.3),
        Colors.transparent,
      ],
    );

// ============================================================================
// BORDER RADIUS - Modern, Varied Sizes
// ============================================================================

const double radiusXSmall = 6.0;
const double radiusSmall = 12.0;
const double radiusMedium = 16.0;
const double radiusLarge = 24.0;
const double radiusXLarge = 32.0;
const double radiusXXLarge = 48.0;
const double radiusFull = 9999.0;

// ============================================================================
// ELEVATION LEVELS
// ============================================================================

const double elevation0 = 0.0;
const double elevation1 = 2.0;
const double elevation2 = 4.0;
const double elevation3 = 8.0;
const double elevation4 = 12.0;
const double elevation5 = 16.0;

// ============================================================================
// ANIMATION DURATIONS
// ============================================================================

const Duration animationFast = Duration(milliseconds: 150);
const Duration animationNormal = Duration(milliseconds: 300);
const Duration animationSlow = Duration(milliseconds: 500);
const Duration animationXSlow = Duration(milliseconds: 800);

// ============================================================================
// ANIMATION CURVES - Modern, Smooth
// ============================================================================

const Curve curveSmooth = Curves.easeInOutCubic;
const Curve curveSnappy = Curves.easeOutCubic;
const Curve curveBounce = Curves.easeOutBack;
const Curve curveElastic = Curves.elasticOut;

// ============================================================================
// TYPOGRAPHY WEIGHTS - Extended Scale
// ============================================================================

const FontWeight weightThin = FontWeight.w100;
const FontWeight weightExtraLight = FontWeight.w200;
const FontWeight weightLight = FontWeight.w300;
const FontWeight weightRegular = FontWeight.w400;
const FontWeight weightMedium = FontWeight.w500;
const FontWeight weightSemiBold = FontWeight.w600;
const FontWeight weightBold = FontWeight.w700;
const FontWeight weightExtraBold = FontWeight.w800;
const FontWeight weightBlack = FontWeight.w900;

// ============================================================================
// ICON SIZES - Comprehensive Scale
// ============================================================================

const double iconXSmall = 12.0;
const double iconSmall = 16.0;
const double iconMedium = 24.0;
const double iconLarge = 32.0;
const double iconXLarge = 48.0;
const double iconXXLarge = 64.0;
const double iconHero = 96.0;

// ============================================================================
// OPACITY VALUES - For Glassmorphism & Overlays
// ============================================================================

const double opacityDisabled = 0.38;
const double opacityMedium = 0.6;
const double opacityHigh = 0.87;
const double opacityGlass = 0.1;
const double opacityOverlay = 0.5;
