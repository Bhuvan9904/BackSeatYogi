import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../navigation/app_router.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final bool showBottomNavigation;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    this.showBottomNavigation = true,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: widget.showBottomNavigation 
          ? _buildResponsiveBottomNavigation()
          : null,
    );
  }

  Widget _buildResponsiveBottomNavigation() {
    final responsiveHeight = ResponsiveUtils.getResponsiveBottomNavHeight(context);
    final responsivePadding = ResponsiveUtils.getResponsiveHorizontalPadding(context);
    final responsiveIconSize = ResponsiveUtils.getResponsiveIconSize(context, 20.0);
    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(context, 10.0);
    
    // Get the bottom padding to account for safe area
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: responsiveHeight + bottomPadding, // Add bottom padding to total height
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: responsivePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildNavItem(
                      Icons.home,
                      'Home',
                      0,
                      responsiveIconSize,
                      responsiveFontSize,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      Icons.self_improvement,
                      'Practice',
                      1,
                      responsiveIconSize,
                      responsiveFontSize,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      Icons.book,
                      'Journal',
                      2,
                      responsiveIconSize,
                      responsiveFontSize,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      Icons.history,
                      'Logs',
                      3,
                      responsiveIconSize,
                      responsiveFontSize,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      Icons.settings,
                      'Settings',
                      4,
                      responsiveIconSize,
                      responsiveFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add bottom safe area
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    double iconSize,
    double fontSize,
  ) {
    final isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _navigateToScreen(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive 
                    ? AppColors.primaryCTA.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isActive
                    ? AppColors.primaryCTA
                    : AppColors.textSecondary,
                size: iconSize,
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child:               Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? AppColors.primaryCTA
                      : AppColors.textSecondary,
                  fontSize: fontSize,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(int index) {
    if (widget.currentIndex == index) return; // Already on this screen

    switch (index) {
      case 0:
        NavigationService.navigateToReplacement(AppRouter.home);
        break;
      case 1:
        NavigationService.navigateToReplacement(AppRouter.practice);
        break;
      case 2:
        NavigationService.navigateToReplacement(AppRouter.reflection);
        break;
      case 3:
        NavigationService.navigateToReplacement(AppRouter.travelLogs);
        break;
      case 4:
        NavigationService.navigateToReplacement(AppRouter.settings);
        break;
    }
  }
}

/// Responsive app bar with enhanced design
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool isResponsive;

  const ResponsiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = isResponsive
        ? ResponsiveUtils.getResponsiveAppBarHeight(context)
        : kToolbarHeight;

    final responsiveFontSize = isResponsive
        ? ResponsiveUtils.getResponsiveFontSize(context, 20.0)
        : 20.0;

    return AppBar(
      automaticallyImplyLeading: false, // Prevent automatic back button
      title: Text(
        title,
        style: TextStyle(
          fontSize: responsiveFontSize,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? AppColors.textLight,
        ),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textLight,
      elevation: elevation ?? 0,
      toolbarHeight: responsiveHeight,
      iconTheme: IconThemeData(
        color: foregroundColor ?? AppColors.textLight,
        size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}

/// Responsive drawer for larger screens
class ResponsiveDrawer extends StatelessWidget {
  final Widget child;
  final bool isResponsive;

  const ResponsiveDrawer({
    super.key,
    required this.child,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isResponsive || ResponsiveUtils.isMobile(context)) {
      return Drawer(child: child);
    }

    // For larger screens, show as a side panel
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.surfaceVariant, width: 1),
        ),
      ),
      child: child,
    );
  }
}
