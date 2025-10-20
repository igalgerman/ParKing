/// Reusable button component with consistent styling.
/// 
/// Supports multiple variants (primary, secondary, text) and sizes.
/// Includes loading state and disabled state handling.
library;

import 'package:flutter/material.dart';
import '../../core/design/app_spacing.dart';

/// Button variant type
enum AppButtonVariant {
  primary, // Filled with primary color
  secondary, // Filled with secondary color
  outlined, // Outlined style
  text, // Text only, no background
}

/// Button size
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Custom button widget with consistent ParKing branding
class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine button height based on size
    final double height = switch (size) {
      AppButtonSize.small => buttonHeightSmall,
      AppButtonSize.medium => buttonHeightMedium,
      AppButtonSize.large => buttonHeightLarge,
    };

    // Determine padding based on size
    final EdgeInsets padding = switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceSmall,
        ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: spaceLarge,
          vertical: spaceMedium,
        ),
      AppButtonSize.large => const EdgeInsets.symmetric(
          horizontal: spaceXLarge,
          vertical: spaceMedium,
        ),
    };

    // Determine text style based on size
    final TextStyle textStyle = switch (size) {
      AppButtonSize.small => theme.textTheme.labelMedium!,
      AppButtonSize.medium => theme.textTheme.titleMedium!,
      AppButtonSize.large => theme.textTheme.titleLarge!,
    };

    final Widget buttonContent = isLoading
        ? SizedBox(
            height: iconSizeMedium,
            width: iconSizeMedium,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary ||
                        variant == AppButtonVariant.secondary
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: size == AppButtonSize.small
                      ? iconSizeSmall
                      : iconSizeMedium,
                ),
                const SizedBox(width: spaceSmall),
              ],
              Text(text, style: textStyle),
            ],
          );

    final Widget button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: Size.fromHeight(height),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
          child: buttonContent,
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: Size.fromHeight(height),
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
          child: buttonContent,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            minimumSize: Size.fromHeight(height),
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.outline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
          child: buttonContent,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            minimumSize: Size.fromHeight(height),
            foregroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
          ),
          child: buttonContent,
        ),
    };

    return fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
