import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';

class CustomCard extends StatelessWidget {
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
  final LinearGradient? gradient;

  const CustomCard({
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
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveRadius = isResponsive 
        ? ResponsiveUtils.getResponsiveCardRadius(context)
        : borderRadius?.topLeft.x ?? 16.0;
    
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? const EdgeInsets.all(16.0);

    final cardDecoration = _buildCardDecoration(responsiveRadius);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        decoration: cardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(responsiveRadius),
          child: useGlassmorphism
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: responsivePadding,
                    decoration: BoxDecoration(
                      color: (backgroundColor ?? AppColors.surface).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(responsiveRadius),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: child,
                  ),
                )
              : Container(
                  padding: responsivePadding,
                  child: child,
                ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(double radius) {
    if (useGradient) {
      return BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCTA.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      );
    }

    return BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: elevation != null
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
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

/// Gradient card with enhanced visual appeal
class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final bool isResponsive;

  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.gradient,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveRadius = isResponsive 
        ? ResponsiveUtils.getResponsiveCardRadius(context)
        : 16.0;
    
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? const EdgeInsets.all(16.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(responsiveRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryCTA.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: responsivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Glass morphism card effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double blurRadius;
  final bool isResponsive;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.blurRadius = 10.0,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveRadius = isResponsive 
        ? ResponsiveUtils.getResponsiveCardRadius(context)
        : 16.0;
    
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? const EdgeInsets.all(16.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(responsiveRadius),
          border: Border.all(
            color: AppColors.textLight.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: blurRadius,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(responsiveRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
            child: Padding(
              padding: responsivePadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
