import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      headlineLarge: bodyTextTheme.headlineLarge?.copyWith(fontSize: 32.sp),
      headlineMedium: bodyTextTheme.headlineMedium?.copyWith(fontSize: 28.sp),
      headlineSmall: bodyTextTheme.headlineSmall?.copyWith(fontSize: 24.sp),
      bodyLarge: bodyTextTheme.bodyLarge?.copyWith(fontSize: 16.sp),
      bodyMedium: bodyTextTheme.bodyMedium?.copyWith(fontSize: 14.sp),
      bodySmall: bodyTextTheme.bodySmall?.copyWith(fontSize: 12.sp),
      labelLarge: bodyTextTheme.labelLarge?.copyWith(fontSize: 14.sp),
      labelMedium: bodyTextTheme.labelMedium?.copyWith(fontSize: 12.sp),
      labelSmall: bodyTextTheme.labelSmall?.copyWith(fontSize: 11.sp),
    );
    return textTheme;
  }
}
