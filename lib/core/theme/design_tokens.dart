import 'package:flutter/material.dart';

/// Brand + semantic colors — the single source of truth referenced by
/// `docs/architecture.md` §4. Collapses the old `strongRed`/`buttonColor`/
/// `orangeOutC` triple (all literally the same navy hex, a leftover from a
/// past rebrand) into one honestly-named `primary`.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1B2A6B);
  static const Color secondary = Color(0xff35459c);
  static const Color accentMagenta = Color(0xFFD5436A);
  static const Color accentPink = Color(0xFFFB8585);
  static const Color skyBlue = Color(0xFF6FA8DC);

  static const Color success = Color(0xff008000);
  static const Color warning = Color(0xffE0A800);
  static const Color error = Color(0xffbd0c21);

  static const Color textPrimary = Color(0xff222222);
  static const Color textSecondary = Color(0xff444444);
  static const Color border = Color(0xffE0E0E0);
  static const Color surfaceGrey = Color(0xFFA7A7AA);

  // Incidental UI greys that don't map to a Material ColorScheme role —
  // named here instead of left as raw hex literals in screens (e.g.
  // `lib/sidemenu/sidemenu.dart`'s row labels/panels).
  static const Color rowLabel = Color(0xff626365);
  static const Color panelBackground = Color(0xffF7F7F7);
  static const Color sheetBackground = Color(0xffFFF7F7);
  static const Color pickerText = Color(0xff303135);

  // Flights form-field chrome (book_domestic_flight.dart / book_flight_formpage.dart).
  static const Color fieldBorder = Color(0xffC2C2C2);
  static const Color subtleBackground = Color(0xFFF4F5F9);
  static const Color hintText = Color(0xB3979797);
}

/// Dark-theme palette — kept as its own token set rather than reusing
/// [AppColors] because `app_dark_theme_data.dart` already had a distinct,
/// deliberately-chosen dark palette before this migration. `main.dart` forces
/// `ThemeMode.light`, so this theme is unreachable at runtime today; these
/// constants just make sure it stays token-sourced (not hand-typed
/// `Color.fromRGBO(...)` at every call site) instead of changing its look.
class AppDarkColors {
  AppDarkColors._();

  static const Color primary = Color.fromRGBO(50, 45, 120, 1);
  static const Color secondary = Color.fromRGBO(34, 193, 224, 1);
  static const Color background = Color.fromRGBO(9, 35, 55, 1);
  static const Color error = Color.fromRGBO(241, 95, 109, 1);
}

/// Named type scale sized for this app's actual UI density (cards, buttons,
/// fare tables) — replaces Material 2's oversized 112px-default scale that
/// `app_text_theme.dart` used to build its `TextTheme` from.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Poppins';

  static const double displaySize = 32.0;
  static const FontWeight displayWeight = FontWeight.w600;
  static const double displayHeight = 1.2;

  static const double headlineSize = 24.0;
  static const FontWeight headlineWeight = FontWeight.w600;
  static const double headlineHeight = 1.25;

  static const double titleSize = 20.0;
  static const FontWeight titleWeight = FontWeight.w600;
  static const double titleHeight = 1.3;

  static const double bodySize = 15.0;
  static const FontWeight bodyWeight = FontWeight.w400;
  static const double bodyHeight = 1.4;

  static const double labelSize = 13.0;
  static const FontWeight labelWeight = FontWeight.w500;
  static const double labelHeight = 1.3;

  static const double captionSize = 12.0;
  static const FontWeight captionWeight = FontWeight.w400;
  static const double captionHeight = 1.3;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 24.0;
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
}

/// One reserved "glass" hero-surface treatment (see `docs/architecture.md`
/// §4) — consumed by `GlassSurface` (`lib/core/widgets/glass_surface.dart`).
/// Deliberately just the values a frosted panel needs, not a general theming
/// mechanism.
@immutable
class GlassStyle {
  const GlassStyle({
    required this.blurSigma,
    required this.tintColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  final double blurSigma;
  final Color tintColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
}

/// The one piece of the token system that goes through Flutter's real
/// `ThemeExtension` mechanism rather than a plain static class — it's the
/// part a future white-label brand is most likely to want to vary, and it
/// needs to be reachable via `Theme.of(context)`.
@immutable
class GlassThemeExtension extends ThemeExtension<GlassThemeExtension> {
  const GlassThemeExtension({required this.hero});

  final GlassStyle hero;

  static const GlassThemeExtension light = GlassThemeExtension(
    hero: GlassStyle(
      blurSigma: 18,
      tintColor: Color(0x33FFFFFF),
      borderColor: Color(0x40FFFFFF),
      borderWidth: 1,
      borderRadius: AppRadius.lg,
    ),
  );

  @override
  GlassThemeExtension copyWith({GlassStyle? hero}) {
    return GlassThemeExtension(hero: hero ?? this.hero);
  }

  @override
  GlassThemeExtension lerp(ThemeExtension<GlassThemeExtension>? other, double t) {
    if (other is! GlassThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}
