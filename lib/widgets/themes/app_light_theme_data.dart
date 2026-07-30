import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/widgets/themes/app_text_theme.dart';

ThemeData appLightThemeData() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
      outline: AppColors.border,
    ),
    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.white,

    /// Text theme
    textTheme: appTextTheme,

    /// AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: appTextTheme.headlineSmall?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: AppColors.primary),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
    ),

    /// elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // `minimumSize`, not `fixedSize` — a fixed width of `double.maxFinite`
        // demands (near) infinite width from every ElevatedButton, which only
        // "worked" for buttons already forced full-width by their own parent
        // (a `SizedBox(width: double.infinity, ...)` or a `Column` with
        // `CrossAxisAlignment.stretch`). Any button sharing a `Row` with other
        // content (e.g. a bottom bar's fare info + "Continue"/"Proceed"
        // button) overflowed by exactly `double.maxFinite` pixels.
        minimumSize: const Size(64, 48),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        elevation: 0,
      ),
    ),

    /// popup TabBar theme
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      textStyle: appTextTheme.titleSmall?.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    /// input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      floatingLabelStyle: appTextTheme.labelLarge?.copyWith(
        color: AppColors.primary,
      ),
      isDense: true,
      iconColor: AppColors.primary,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
    ),

    /// progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),

    extensions: const <ThemeExtension<dynamic>>[
      GlassThemeExtension.light,
    ],
  );
}
