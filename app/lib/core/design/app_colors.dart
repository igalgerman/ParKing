/// ParKing App Color Palette - Modern Branding
/// 
/// Contemporary design with vibrant gradients, glassmorphism, and bold accents.
/// Inspired by modern mobile app design trends with premium feel.
library;

import 'package:flutter/material.dart';

// ============================================================================
// PRIMARY BRAND COLORS - Modern Purple/Blue Theme
// ============================================================================

/// Primary brand color - Electric violet for innovation and premium feel
const Color parkingPrimary = Color(0xFF6366F1); // Vibrant indigo
const Color parkingPrimaryDark = Color(0xFF4F46E5); // Deep indigo
const Color parkingPrimaryLight = Color(0xFF818CF8); // Light indigo

/// Secondary brand color - Vibrant cyan for energy and modernity
const Color parkingSecondary = Color(0xFF06B6D4); // Bright cyan
const Color parkingSecondaryDark = Color(0xFF0891B2); // Deep cyan
const Color parkingSecondaryLight = Color(0xFF22D3EE); // Light cyan

/// Accent color - Energetic pink for CTAs and highlights
const Color parkingAccent = Color(0xFFEC4899); // Vibrant pink
const Color parkingAccentDark = Color(0xFFDB2777); // Deep pink
const Color parkingAccentLight = Color(0xFFF472B6); // Light pink

// ============================================================================
// SEMANTIC COLORS - Modern Palette
// ============================================================================

const Color parkingSuccess = Color(0xFF10B981); // Emerald green
const Color parkingWarning = Color(0xFFF59E0B); // Amber
const Color parkingError = Color(0xFFEF4444); // Modern red
const Color parkingInfo = Color(0xFF3B82F6); // Bright blue

// ============================================================================
// NEUTRAL COLORS - Light Mode
// ============================================================================

const Color parkingBackground = Color(0xFFF8FAFC); // Slate 50
const Color parkingSurface = Color(0xFFFFFFFF); // Pure white
const Color parkingSurfaceVariant = Color(0xFFF1F5F9); // Slate 100
const Color parkingOnSurface = Color(0xFF0F172A); // Slate 900
const Color parkingOnSurfaceVariant = Color(0xFF64748B); // Slate 500

// ============================================================================
// NEUTRAL COLORS - Dark Mode
// ============================================================================

const Color parkingBackgroundDark = Color(0xFF0F172A); // Slate 900
const Color parkingSurfaceDark = Color(0xFF1E293B); // Slate 800
const Color parkingSurfaceVariantDark = Color(0xFF334155); // Slate 700
const Color parkingOnSurfaceDark = Color(0xFFF8FAFC); // Slate 50
const Color parkingOnSurfaceVariantDark = Color(0xFF94A3B8); // Slate 400

// ============================================================================
// MODERN GRADIENTS - Primary Feature
// ============================================================================

/// Main hero gradient - Purple to blue diagonal
const List<Color> parkingHeroGradient = [
  Color(0xFF6366F1), // Indigo
  Color(0xFF8B5CF6), // Violet
  Color(0xFFA855F7), // Purple
];

/// Secondary gradient - Cyan to blue
const List<Color> parkingAccentGradient = [
  Color(0xFF06B6D4), // Cyan
  Color(0xFF3B82F6), // Blue
  Color(0xFF6366F1), // Indigo
];

/// Success gradient - Green tones
const List<Color> parkingSuccessGradient = [
  Color(0xFF10B981), // Emerald
  Color(0xFF059669), // Emerald dark
];

/// Warm gradient - Pink to orange
const List<Color> parkingWarmGradient = [
  Color(0xFFEC4899), // Pink
  Color(0xFFF97316), // Orange
  Color(0xFFFBBF24), // Amber
];

/// Glassmorphic overlay colors
const Color parkingGlassWhite = Color(0x1AFFFFFF); // 10% white
const Color parkingGlassBlack = Color(0x1A000000); // 10% black

// ============================================================================
// MODERN SHADOWS WITH COLOR TINTS
// ============================================================================

/// Primary shadow color with purple tint
const Color parkingShadowPrimary = Color(0x206366F1);

/// Secondary shadow color with cyan tint
const Color parkingShadowSecondary = Color(0x2006B6D4);

/// Accent shadow color with pink tint
const Color parkingShadowAccent = Color(0x20EC4899);

/// Neutral shadow for cards
const Color parkingShadowNeutral = Color(0x0A000000);
