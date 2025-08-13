import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';

enum ButtonType { primary, secondary, outline, text, gradient }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isResponsive;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final LinearGradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.isResponsive = true,
    this.padding,
    this.borderRadius,
    this.gradient,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
    final responsiveHeight = widget.isResponsive
        ? ResponsiveUtils.getResponsiveButtonHeight(context)
        : widget.height ?? 50.0;

    final responsivePadding = widget.padding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.getResponsiveSpacing(context),
      vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
    );

    final responsiveBorderRadius = widget.borderRadius ?? 
        BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.75);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (widget.onPressed != null) {
                setState(() => _isPressed = true);
                _animationController.forward();
              }
            },
            onTapUp: (_) {
              if (widget.onPressed != null) {
                setState(() => _isPressed = false);
                _animationController.reverse();
              }
            },
            onTapCancel: () {
              if (widget.onPressed != null) {
                setState(() => _isPressed = false);
                _animationController.reverse();
              }
            },
            child: Container(
              width: widget.width,
              height: responsiveHeight,
              decoration: _buildButtonDecoration(responsiveBorderRadius),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: responsiveBorderRadius,
                  onTap: widget.isLoading ? null : widget.onPressed,
                  child: Container(
                    padding: responsivePadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading)
                          SizedBox(
                            width: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
                            height: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getTextColor(),
                              ),
                            ),
                          )
                        else if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: _getTextColor(),
                            size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                          ),
                          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                        ],
                        Flexible(
                          child: Text(
                            widget.text,
                            style: AppTypography.bodyLarge(context).copyWith(
                              color: _getTextColor(),
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildButtonDecoration(BorderRadius borderRadius) {
    switch (widget.type) {
      case ButtonType.primary:
        return BoxDecoration(
          gradient: widget.gradient ?? AppColors.primaryGradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryCTA.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        );
      case ButtonType.secondary:
        return BoxDecoration(
          gradient: widget.gradient ?? AppColors.secondaryGradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryCTA.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        );
      case ButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: borderRadius,
          border: Border.all(
            color: AppColors.primaryCTA,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryCTA.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        );
      case ButtonType.gradient:
        return BoxDecoration(
          gradient: widget.gradient ?? AppColors.primaryGradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryCTA.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
              spreadRadius: 0,
            ),
          ],
        );
      case ButtonType.text:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: borderRadius,
        );
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.gradient:
        return AppColors.textLight;
      case ButtonType.outline:
      case ButtonType.text:
        return AppColors.primaryCTA;
    }
  }
}

/// Gradient button with enhanced visual appeal
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final Gradient? gradient;
  final bool isResponsive;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.gradient,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = isResponsive
        ? ResponsiveUtils.getResponsiveButtonHeight(context)
        : height ?? 50.0;

    final responsivePadding = EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.getResponsiveSpacing(context),
      vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
    );

    final responsiveBorderRadius = BorderRadius.circular(
      ResponsiveUtils.getResponsiveCardRadius(context) * 0.75,
    );

    return SizedBox(
      width: width,
      height: responsiveHeight,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          borderRadius: responsiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryCTA.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: responsiveBorderRadius,
            child: Padding(
              padding: responsivePadding,
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textLight),
        ),
      );
    }

    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(context, 16.0);
    final responsiveIconSize = ResponsiveUtils.getResponsiveIconSize(context, 20.0);

    return Row(
                mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
          Icon(icon, size: responsiveIconSize, color: AppColors.textLight),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  ],
                  Text(
                    text,
          style: TextStyle(
            fontSize: responsiveFontSize,
                      fontWeight: FontWeight.w600,
            color: AppColors.textLight,
                    ),
                  ),
                ],
    );
  }
}

/// Floating action button with responsive design
class ResponsiveFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isResponsive;

  const ResponsiveFAB({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveIconSize = isResponsive
        ? ResponsiveUtils.getResponsiveIconSize(context, 24.0)
        : 24.0;

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primaryCTA,
      foregroundColor: foregroundColor ?? AppColors.textLight,
      tooltip: tooltip,
      child: Icon(icon, size: responsiveIconSize),
    );
  }
}
