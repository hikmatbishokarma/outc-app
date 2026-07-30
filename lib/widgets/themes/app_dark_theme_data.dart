import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';

import 'app_text_theme.dart';

/// `main.dart` forces `ThemeMode.light`, so this theme is unreachable at
/// runtime today — it's kept token-sourced (via [AppDarkColors]) rather than
/// hand-typed `Color.fromRGBO(...)` so it doesn't silently drift out of sync
/// with the token system, not because its look changed in this migration.
ThemeData appDarkThemeData() {
  return ThemeData(
    colorScheme: const ColorScheme(
      primary: AppDarkColors.primary,
      secondary: AppDarkColors.secondary,
      surface: Colors.white54,
      error: AppDarkColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppDarkColors.background,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),

    /// AppBar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppDarkColors.background,
      elevation: 0,
      titleTextStyle: appTextTheme.headlineSmall?.copyWith(
        color: AppDarkColors.secondary,
        fontWeight: FontWeight.w700,
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelStyle: TextStyle(color: AppDarkColors.secondary),
      unselectedLabelStyle: TextStyle(color: Colors.white),
      indicatorColor: AppDarkColors.secondary,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppDarkColors.background,
      selectedItemColor: AppDarkColors.secondary,
      unselectedItemColor: Colors.white,
    ),

    /// Button theme
    buttonTheme: const ButtonThemeData(
      shape: RoundedRectangleBorder(),
      disabledColor: Color.fromRGBO(34, 193, 224, 0.1),
      buttonColor: AppDarkColors.secondary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // See app_light_theme_data.dart — `minimumSize`, not `fixedSize`,
        // for the same reason (fixedSize forces near-infinite width on any
        // button sharing a Row with other content).
        minimumSize: const Size(64, 48),
        foregroundColor: Colors.white,
        backgroundColor: AppDarkColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        elevation: 0,
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      textStyle: appTextTheme.titleSmall?.copyWith(
        color: Colors.white,
      ),
    ),

    /// Text theme
    textTheme: appTextTheme,

    inputDecorationTheme: InputDecorationTheme(
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(
          color: AppDarkColors.error,
          width: 1,
        ),
      ),
      floatingLabelStyle: appTextTheme.labelLarge?.copyWith(
        color: Colors.white,
      ),
      labelStyle: appTextTheme.labelLarge?.copyWith(
        color: Colors.white,
      ),
      isDense: true,
      iconColor: AppDarkColors.secondary,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(
          color: AppDarkColors.secondary,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(
          color: AppDarkColors.primary,
        ),
      ),
    ),

    extensions: const <ThemeExtension<dynamic>>[
      GlassThemeExtension.light,
    ],
  );
}
