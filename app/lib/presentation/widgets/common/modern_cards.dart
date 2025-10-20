/// Modern Glassmorphic Card Component
/// 
/// Features blur effects, gradient borders, and contemporary styling.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app/core/design/app_colors.dart';
import 'package:app/core/design/design_constants.dart';
import 'package:app/core/design/app_spacing.dart';

/// Modern card with glassmorphic effect
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradient,
    this.blur = glassBlurStrength,
    this.opacity = opacityGlass,
    this.hasBorder = true,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Gradient? gradient;
  final double blur;
  final double opacity;
  final bool hasBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final radius = borderRadius ?? radiusLarge;

    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(spaceLarge),
          margin: margin,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(opacity)
                : Colors.white.withOpacity(opacity + 0.05),
            borderRadius: BorderRadius.circular(radius),
            border: hasBorder
                ? Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  )
                : null,
            gradient: gradient,
            boxShadow: cardShadow,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Modern elevated card with gradient and shadow
class ModernCard extends StatelessWidget {
  const ModernCard({
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.color,
    this.borderRadius,
    this.shadow,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? shadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? radiusLarge;

    final card = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: spaceSmall),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surface,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ?? cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(spaceLarge),
              child: child,
            ),
          ),
        ),
      ),
    );

    return card;
  }
}

/// Gradient container with modern styling
class GradientContainer extends StatelessWidget {
  const GradientContainer({
    required this.child,
    required this.gradient,
    this.padding,
    this.borderRadius,
    this.height,
    this.width,
    super.key,
  });

  final Widget child;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
      ),
      child: child,
    );
  }
}
