import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool isResponsive;
  final bool useGradient;
  final bool useGlassmorphism;
  final bool useHoverEffect;
  final LinearGradient? gradient;
  final String? title;
  final IconData? icon;
  final Color? iconColor;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
    this.isResponsive = true,
    this.useGradient = false,
    this.useGlassmorphism = false,
    this.useHoverEffect = false,
    this.gradient,
    this.title,
    this.icon,
    this.iconColor,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveRadius = widget.isResponsive
        ? ResponsiveUtils.getResponsiveCardRadius(context)
        : widget.borderRadius?.topLeft.x ?? 16.0;

    final responsivePadding = widget.isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : widget.padding ?? const EdgeInsets.all(16.0);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.useHoverEffect ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) {
              if (widget.useHoverEffect && widget.onTap != null) {
                _animationController.forward();
              }
            },
            onTapUp: (_) {
              if (widget.useHoverEffect && widget.onTap != null) {
                _animationController.reverse();
              }
            },
            onTapCancel: () {
              if (widget.useHoverEffect && widget.onTap != null) {
                _animationController.reverse();
              }
            },
            child: Container(
              margin: widget.margin ?? EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              decoration: _buildCardDecoration(responsiveRadius),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(responsiveRadius),
                child: widget.useGlassmorphism
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: responsivePadding,
                          decoration: BoxDecoration(
                            color: (widget.backgroundColor ?? AppColors.surface).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(responsiveRadius),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: _buildCardContent(),
                        ),
                      )
                    : Container(
                        padding: responsivePadding,
                        child: _buildCardContent(),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    if (widget.title != null || widget.icon != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null || widget.icon != null) ...[
            Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.iconColor ?? AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                ],
                if (widget.title != null)
                  Expanded(
                    child: Text(
                      widget.title!,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
          ],
          widget.child,
        ],
      );
    }
    return widget.child;
  }

  BoxDecoration _buildCardDecoration(double radius) {
    final elevation = widget.elevation ?? 8.0;
    final elevationMultiplier = widget.useHoverEffect ? _elevationAnimation.value : 1.0;

    if (widget.useGradient) {
      return BoxDecoration(
        gradient: widget.gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCTA.withOpacity(0.3 * elevationMultiplier),
            blurRadius: 20 * elevationMultiplier,
            offset: Offset(0, 8 * elevationMultiplier),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1 * elevationMultiplier),
            blurRadius: 8 * elevationMultiplier,
            offset: Offset(0, 4 * elevationMultiplier),
            spreadRadius: 0,
          ),
        ],
      );
    }

    return BoxDecoration(
      color: widget.backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15 * elevationMultiplier),
          blurRadius: 12 * elevationMultiplier,
          offset: Offset(0, 6 * elevationMultiplier),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.primary.withOpacity(0.1 * elevationMultiplier),
          blurRadius: 4 * elevationMultiplier,
          offset: Offset(0, 2 * elevationMultiplier),
          spreadRadius: 0,
        ),
      ],
      border: Border.all(
        color: AppColors.primary.withOpacity(0.1),
        width: 1,
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      gradient: gradient,
      useGradient: true,
      useHoverEffect: true,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      useGlassmorphism: true,
      useHoverEffect: true,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
}
