import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_theme_extension.dart';

abstract class AppTheme {
  // AquaBlue scheme'e karşılık gelen renkler
  static const Color _primaryLight = Color(0xFF0277BD);
  static const Color _secondaryLight = Color(0xFF00838F);
  static const Color _tertiaryLight = Color(0xFF006064);

  static const Color _primaryDark = Color(0xFF4FC3F7);
  static const Color _secondaryDark = Color(0xFF4DD0E1);
  static const Color _tertiaryDark = Color(0xFF80DEEA);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryLight,
      secondary: _secondaryLight,
      tertiary: _tertiaryLight,
      brightness: Brightness.light,
      surface: const Color(0xFFF4F6F8),
      surfaceContainerLow: const Color(0xFFEEF2F5),
      surfaceContainer: const Color(0xFFE8EDF1),
    ),
    extensions: [AppThemeExtension.light],
    dividerTheme: const DividerThemeData(
      color: Color(0x1F000000),
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    ),
    textTheme: Typography.material2021().black,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryDark,
      secondary: _secondaryDark,
      tertiary: _tertiaryDark,
      brightness: Brightness.dark,
      surface: const Color(0xFF0F1923),
      surfaceContainerLow: const Color(0xFF141F2B),
      surfaceContainer: const Color(0xFF192533),
    ),
    extensions: [AppThemeExtension.dark],
    dividerTheme: const DividerThemeData(
      color: Color(0x1FFFFFFF),
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    ),
    textTheme: Typography.material2021().white,
  );
}
