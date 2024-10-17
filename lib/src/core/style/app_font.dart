import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static TextTheme createTextTheme(
      BuildContext context, String bodyFontString, String displayFontString) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme =
        GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme =
        GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    TextTheme textTheme = displayTextTheme.copyWith(
      headlineLarge: bodyTextTheme.headlineLarge?.copyWith(fontSize: 32),
      headlineMedium: bodyTextTheme.headlineMedium?.copyWith(fontSize: 28),
      headlineSmall: bodyTextTheme.headlineSmall?.copyWith(fontSize: 24),
      bodyLarge: bodyTextTheme.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: bodyTextTheme.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: bodyTextTheme.bodySmall?.copyWith(fontSize: 12),
      labelLarge: bodyTextTheme.labelLarge?.copyWith(fontSize: 14),
      labelMedium: bodyTextTheme.labelMedium?.copyWith(fontSize: 12),
      labelSmall: bodyTextTheme.labelSmall?.copyWith(fontSize: 11),
    );
    return textTheme;
  }
}
