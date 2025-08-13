import 'package:flutter/material.dart';

/// Responsive design utilities for different screen sizes
class ResponsiveUtils {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;

  /// Get screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < _mobileBreakpoint) return ScreenSize.mobile;
    if (width < _tabletBreakpoint) return ScreenSize.tablet;
    if (width < _desktopBreakpoint) return ScreenSize.desktop;
    return ScreenSize.largeDesktop;
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context) == ScreenSize.desktop;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32.0);
      case ScreenSize.largeDesktop:
        return const EdgeInsets.all(40.0);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.symmetric(horizontal: 16.0);
      case ScreenSize.tablet:
        return const EdgeInsets.symmetric(horizontal: 24.0);
      case ScreenSize.desktop:
        return const EdgeInsets.symmetric(horizontal: 32.0);
      case ScreenSize.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 40.0);
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return 16.0;
      case ScreenSize.tablet:
        return 24.0;
      case ScreenSize.desktop:
        return 32.0;
      case ScreenSize.largeDesktop:
        return 40.0;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return baseSize;
      case ScreenSize.tablet:
        return baseSize * 1.1;
      case ScreenSize.desktop:
        return baseSize * 1.2;
      case ScreenSize.largeDesktop:
        return baseSize * 1.3;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return baseSize;
      case ScreenSize.tablet:
        return baseSize * 1.2;
      case ScreenSize.desktop:
        return baseSize * 1.4;
      case ScreenSize.largeDesktop:
        return baseSize * 1.6;
    }
  }

  /// Get responsive card radius
  static double getResponsiveCardRadius(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return 12.0;
      case ScreenSize.tablet:
        return 16.0;
      case ScreenSize.desktop:
        return 20.0;
      case ScreenSize.largeDesktop:
        return 24.0;
    }
  }

  /// Get responsive button height
  static double getResponsiveButtonHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return 48.0;
      case ScreenSize.tablet:
        return 56.0;
      case ScreenSize.desktop:
        return 64.0;
      case ScreenSize.largeDesktop:
        return 72.0;
    }
  }

  /// Get responsive app bar height
  static double getResponsiveAppBarHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return kToolbarHeight;
      case ScreenSize.tablet:
        return kToolbarHeight * 1.2;
      case ScreenSize.desktop:
        return kToolbarHeight * 1.4;
      case ScreenSize.largeDesktop:
        return kToolbarHeight * 1.6;
    }
  }

  /// Get responsive bottom navigation height
  static double getResponsiveBottomNavHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return 70.0; // Reduced from 80.0
      case ScreenSize.tablet:
        return 90.0; // Reduced from 100.0
      case ScreenSize.desktop:
        return 110.0; // Reduced from 120.0
      case ScreenSize.largeDesktop:
        return 130.0; // Reduced from 140.0
    }
  }

  /// Get responsive grid cross axis count
  static int getResponsiveGridCrossAxisCount(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return 1;
      case ScreenSize.tablet:
        return 2;
      case ScreenSize.desktop:
        return 3;
      case ScreenSize.largeDesktop:
        return 4;
    }
  }

  /// Get responsive max width for content
  static double getResponsiveMaxWidth(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return double.infinity;
      case ScreenSize.tablet:
        return 600.0;
      case ScreenSize.desktop:
        return 800.0;
      case ScreenSize.largeDesktop:
        return 1000.0;
    }
  }
}

/// Screen size categories
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Responsive widget that adapts to different screen sizes
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveUtils.getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveUtils.getScreenSize(context);
    return builder(context, screenSize);
  }
}
