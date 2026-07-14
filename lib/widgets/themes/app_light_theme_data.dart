import 'package:flutter/material.dart';
import 'package:outc/widgets/themes/app_text_theme.dart';

ThemeData appLightThemeData() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
    ).copyWith(),
    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.white,

    /// Text theme
    textTheme: appTextTheme,

    /// AppBar theme
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black
        // centerTitle: true,
        // color: Colors.white,
        // elevation: 0,
        // titleTextStyle: appTextTheme.headlineSmall?.copyWith(
        //   color: const Color.fromRGBO(50, 45, 120, 1),
        //   fontWeight: FontWeight.w700,
        // ),
        // actionsIconTheme: const IconThemeData(
        //   color: Color.fromRGBO(50, 45, 120, 1),
        // ),
        // iconTheme: const IconThemeData(
        //   color: Color.fromRGBO(50, 45, 120, 1),
        // ),
        ),

    /// Button theme
    // buttonTheme: const ButtonThemeData(
    //   shape: RoundedRectangleBorder(),
    //   disabledColor: Color.fromRGBO(34, 193, 224, 0.1),
    //   buttonColor: Color.fromRGBO(34, 193, 224, 1),
    // ),

    /// elevated Button Theme
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     fixedSize: const Size(double.maxFinite, 48),
    //     foregroundColor: Colors.white,
    //     backgroundColor: const Color.fromRGBO(50, 45, 120, 1),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     elevation: 0,
    //   ),
    // ),

    /// popup TabBar theme
    // popupMenuTheme: PopupMenuThemeData(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    //   textStyle: appTextTheme.titleSmall?.copyWith(
    //     color: Colors.black,
    //   ),
    // ),

    /// input Decoration Theme
    // inputDecorationTheme: InputDecorationTheme(
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: const BorderSide(
    //       color: Color.fromRGBO(241, 95, 109, 1),
    //       width: 1,
    //     ),
    //   ),
    //   floatingLabelStyle: appTextTheme.labelLarge?.copyWith(
    //     color: const Color.fromRGBO(50, 45, 120, 1),
    //   ),
    //   isDense: true,
    //   iconColor: const Color.fromRGBO(34, 193, 224, 1),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: const BorderSide(
    //       color: Color.fromRGBO(50, 45, 120, 1),
    //       width: 2,
    //     ),
    //   ),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: const BorderSide(
    //       color: Color.fromRGBO(50, 45, 120, 1),
    //     ),
    //   ),
    // ),

    /// progress Indicator Theme
    // progressIndicatorTheme: const ProgressIndicatorThemeData(
    //   color: Colors.black,
    // ),
  );
}
