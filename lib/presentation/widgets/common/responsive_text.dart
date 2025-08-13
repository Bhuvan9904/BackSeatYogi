import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';

/// Responsive text widget with adaptive typography
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveStyle = isResponsive && style != null
        ? ResponsiveUtils.getResponsiveFontSize(context, style!.fontSize ?? 16.0)
        : style?.fontSize ?? 16.0;

    return Text(
      text,
      style: style?.copyWith(fontSize: responsiveStyle) ?? 
          AppTypography.bodyMedium(context).copyWith(fontSize: responsiveStyle),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Display large responsive text
class DisplayLargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const DisplayLargeText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.displayLarge(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Display medium responsive text
class DisplayMediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const DisplayMediumText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.displayMedium(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Display small responsive text
class DisplaySmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const DisplaySmallText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.displaySmall(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Headline large responsive text
class HeadlineLargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const HeadlineLargeText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.headlineLarge(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Headline medium responsive text
class HeadlineMediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const HeadlineMediumText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.headlineMedium(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Headline small responsive text
class HeadlineSmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const HeadlineSmallText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.headlineSmall(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Title large responsive text
class TitleLargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const TitleLargeText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleLarge(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Title medium responsive text
class TitleMediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const TitleMediumText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleMedium(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Title small responsive text
class TitleSmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const TitleSmallText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleSmall(context).copyWith(
        color: color ?? AppColors.textSecondary,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Body large responsive text
class BodyLargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const BodyLargeText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyLarge(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Body medium responsive text
class BodyMediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const BodyMediumText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMedium(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Body small responsive text
class BodySmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const BodySmallText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodySmall(context).copyWith(
        color: color ?? AppColors.textSecondary,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Label large responsive text
class LabelLargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const LabelLargeText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelLarge(context).copyWith(
        color: color ?? AppColors.textLight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Label medium responsive text
class LabelMediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const LabelMediumText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelMedium(context).copyWith(
        color: color ?? AppColors.textSecondary,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Label small responsive text
class LabelSmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const LabelSmallText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelSmall(context).copyWith(
        color: color ?? AppColors.textTertiary,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
