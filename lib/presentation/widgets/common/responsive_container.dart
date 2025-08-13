import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';

/// Responsive container that adapts to different screen sizes
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? maxWidth;
  final bool centerContent;
  final bool isResponsive;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.maxWidth,
    this.centerContent = true,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? EdgeInsets.zero;

    final responsiveMaxWidth = maxWidth ?? ResponsiveUtils.getResponsiveMaxWidth(context);

    Widget content = child;

    if (centerContent) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: responsiveMaxWidth),
          child: child,
        ),
      );
    }

    return Container(
      padding: responsivePadding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: content,
    );
  }
}

/// Responsive grid container for adaptive layouts
class ResponsiveGridContainer extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool isResponsive;

  const ResponsiveGridContainer({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveCrossAxisCount = crossAxisCount ?? 
        ResponsiveUtils.getResponsiveGridCrossAxisCount(context);

    final responsiveSpacing = isResponsive
        ? ResponsiveUtils.getResponsiveSpacing(context)
        : 16.0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: responsiveCrossAxisCount,
      childAspectRatio: childAspectRatio ?? 1.0,
      crossAxisSpacing: crossAxisSpacing ?? responsiveSpacing,
      mainAxisSpacing: mainAxisSpacing ?? responsiveSpacing,
      padding: padding,
      children: children,
    );
  }
}

/// Responsive list container with adaptive spacing
class ResponsiveListContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool isResponsive;

  const ResponsiveListContainer({
    super.key,
    required this.children,
    this.padding,
    this.spacing,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? EdgeInsets.zero;

    final responsiveSpacing = spacing ?? ResponsiveUtils.getResponsiveSpacing(context);

    return Padding(
      padding: responsivePadding,
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          
          if (index == children.length - 1) {
            return child;
          }
          
          return Column(
            children: [
              child,
              SizedBox(height: responsiveSpacing),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Responsive row container for horizontal layouts
class ResponsiveRowContainer extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool isResponsive;

  const ResponsiveRowContainer({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.spacing,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsiveHorizontalPadding(context)
        : padding ?? EdgeInsets.zero;

    final responsiveSpacing = spacing ?? ResponsiveUtils.getResponsiveSpacing(context);

    return Padding(
      padding: responsivePadding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          
          if (index == children.length - 1) {
            return child;
          }
          
          return Row(
            children: [
              child,
              SizedBox(width: responsiveSpacing),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Responsive scroll container with adaptive behavior
class ResponsiveScrollContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool isResponsive;

  const ResponsiveScrollContainer({
    super.key,
    required this.child,
    this.padding,
    this.physics,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? EdgeInsets.zero;

    return SingleChildScrollView(
      padding: responsivePadding,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 
              MediaQuery.of(context).padding.top - 
              MediaQuery.of(context).padding.bottom,
        ),
        child: child,
      ),
    );
  }
}

/// Responsive card container with adaptive styling
class ResponsiveCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isResponsive;

  const ResponsiveCardContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = isResponsive
        ? ResponsiveUtils.getResponsivePadding(context)
        : padding ?? EdgeInsets.all(16.0);

    final responsiveRadius = isResponsive
        ? ResponsiveUtils.getResponsiveCardRadius(context)
        : borderRadius?.topLeft.x ?? 16.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: responsivePadding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: BorderRadius.circular(responsiveRadius),
          boxShadow: elevation != null
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: elevation!,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: AppColors.surfaceVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
