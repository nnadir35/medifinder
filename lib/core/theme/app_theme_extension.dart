import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.spacingXl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.cardColor,
    required this.successColor,
    required this.warningColor,
  });

  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double spacingXl;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final Color cardColor;
  final Color successColor;
  final Color warningColor;

  static AppThemeExtension get light => AppThemeExtension(
    spacingXs: 4.r,
    spacingSm: 8.r,
    spacingMd: 16.r,
    spacingLg: 24.r,
    spacingXl: 32.r,
    radiusSm: 4.r,
    radiusMd: 12.r,
    radiusLg: 24.r,
    cardColor: const Color(0xFFF5F5F5),
    successColor: const Color(0xFF4CAF50),
    warningColor: const Color(0xFFFFC107),
  );

  static AppThemeExtension get dark => AppThemeExtension(
    spacingXs: 4.r,
    spacingSm: 8.r,
    spacingMd: 16.r,
    spacingLg: 24.r,
    spacingXl: 32.r,
    radiusSm: 4.r,
    radiusMd: 12.r,
    radiusLg: 24.r,
    cardColor: const Color(0xFF1E1E1E),
    successColor: const Color(0xFF66BB6A),
    warningColor: const Color(0xFFFFCA28),
  );

  @override
  AppThemeExtension copyWith({
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? spacingXl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    Color? cardColor,
    Color? successColor,
    Color? warningColor,
  }) => AppThemeExtension(
    spacingXs: spacingXs ?? this.spacingXs,
    spacingSm: spacingSm ?? this.spacingSm,
    spacingMd: spacingMd ?? this.spacingMd,
    spacingLg: spacingLg ?? this.spacingLg,
    spacingXl: spacingXl ?? this.spacingXl,
    radiusSm: radiusSm ?? this.radiusSm,
    radiusMd: radiusMd ?? this.radiusMd,
    radiusLg: radiusLg ?? this.radiusLg,
    cardColor: cardColor ?? this.cardColor,
    successColor: successColor ?? this.successColor,
    warningColor: warningColor ?? this.warningColor,
  );

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      spacingXs: spacingXs,
      spacingSm: spacingSm,
      spacingMd: spacingMd,
      spacingLg: spacingLg,
      spacingXl: spacingXl,
      radiusSm: radiusSm,
      radiusMd: radiusMd,
      radiusLg: radiusLg,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
    );
  }
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
