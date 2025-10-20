/// ParKing Design System Spacing
///
/// Consistent spacing scale following 8px grid system.
/// Use these constants throughout the app for uniform spacing.
library;

/// Base spacing unit (8px)
const double spaceUnit = 8.0;

/// Spacing scale
const double space0 = 0.0;
const double space1 = spaceUnit * 0.5; // 4px
const double space2 = spaceUnit; // 8px
const double space3 = spaceUnit * 1.5; // 12px
const double space4 = spaceUnit * 2; // 16px
const double space5 = spaceUnit * 2.5; // 20px
const double space6 = spaceUnit * 3; // 24px
const double space8 = spaceUnit * 4; // 32px
const double space10 = spaceUnit * 5; // 40px
const double space12 = spaceUnit * 6; // 48px
const double space16 = spaceUnit * 8; // 64px

/// Common spacing aliases
const double spaceTiny = space1; // 4px
const double spaceSmall = space2; // 8px
const double spaceMedium = space4; // 16px
const double spaceLarge = space6; // 24px
const double spaceXLarge = space8; // 32px
const double spaceXXLarge = space12; // 48px

/// Screen padding
const double screenPaddingMobile = space4; // 16px
const double screenPaddingTablet = space6; // 24px
const double screenPaddingDesktop = space8; // 32px

/// Border radius
/// NOTE: Border radius constants moved to design_constants.dart for modern design system
/// Legacy constants kept for backward compatibility if needed
const double radiusRound = 999.0; // Fully rounded

/// Icon sizes
const double iconSizeSmall = 16.0;
const double iconSizeMedium = 24.0;
const double iconSizeLarge = 32.0;
const double iconSizeXLarge = 48.0;

/// Button heights
const double buttonHeightSmall = 36.0;
const double buttonHeightMedium = 48.0;
const double buttonHeightLarge = 56.0;

/// Max content width for readability
const double maxContentWidth = 600.0;
const double maxContentWidthWide = 1200.0;
