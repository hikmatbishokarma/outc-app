import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/core/theme/design_tokens.dart';

/// Named type scale built from [AppTypography] — sized for this app's actual
/// UI density (cards, buttons, fare tables), not Material 2's oversized
/// 112px-default scale this file used to copy. `headlineLarge` used to be
/// missing entirely; it's filled in below along with the rest of the scale.
final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(
    fontSize: AppTypography.displaySize + 4,
    fontWeight: AppTypography.displayWeight,
    height: AppTypography.displayHeight,
  ),
  displayMedium: GoogleFonts.poppins(
    fontSize: AppTypography.displaySize,
    fontWeight: AppTypography.displayWeight,
    height: AppTypography.displayHeight,
  ),
  displaySmall: GoogleFonts.poppins(
    fontSize: AppTypography.displaySize - 4,
    fontWeight: AppTypography.displayWeight,
    height: AppTypography.displayHeight,
  ),
  headlineLarge: GoogleFonts.poppins(
    fontSize: AppTypography.headlineSize + 2,
    fontWeight: AppTypography.headlineWeight,
    height: AppTypography.headlineHeight,
  ),
  headlineMedium: GoogleFonts.poppins(
    fontSize: AppTypography.headlineSize,
    fontWeight: AppTypography.headlineWeight,
    height: AppTypography.headlineHeight,
  ),
  headlineSmall: GoogleFonts.poppins(
    fontSize: AppTypography.headlineSize - 4,
    fontWeight: AppTypography.headlineWeight,
    height: AppTypography.headlineHeight,
  ),
  titleLarge: GoogleFonts.poppins(
    fontSize: AppTypography.titleSize + 2,
    fontWeight: AppTypography.titleWeight,
    height: AppTypography.titleHeight,
  ),
  titleMedium: GoogleFonts.poppins(
    fontSize: AppTypography.titleSize,
    fontWeight: AppTypography.titleWeight,
    height: AppTypography.titleHeight,
  ),
  titleSmall: GoogleFonts.poppins(
    fontSize: AppTypography.titleSize - 4,
    fontWeight: AppTypography.titleWeight,
    height: AppTypography.titleHeight,
  ),
  bodyLarge: GoogleFonts.poppins(
    fontSize: AppTypography.bodySize + 2,
    fontWeight: AppTypography.bodyWeight,
    height: AppTypography.bodyHeight,
  ),
  bodyMedium: GoogleFonts.poppins(
    fontSize: AppTypography.bodySize,
    fontWeight: AppTypography.bodyWeight,
    height: AppTypography.bodyHeight,
  ),
  bodySmall: GoogleFonts.poppins(
    fontSize: AppTypography.captionSize,
    fontWeight: AppTypography.bodyWeight,
    height: AppTypography.captionHeight,
  ),
  labelLarge: GoogleFonts.poppins(
    fontSize: AppTypography.labelSize + 2,
    fontWeight: AppTypography.labelWeight,
    height: AppTypography.labelHeight,
  ),
  labelMedium: GoogleFonts.poppins(
    fontSize: AppTypography.labelSize,
    fontWeight: AppTypography.labelWeight,
    height: AppTypography.labelHeight,
  ),
  labelSmall: GoogleFonts.poppins(
    fontSize: AppTypography.captionSize,
    fontWeight: AppTypography.captionWeight,
    height: AppTypography.captionHeight,
  ),
);
