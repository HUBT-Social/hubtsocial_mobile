import "package:flutter/material.dart";

class AppTheme {
  final TextTheme textTheme;

  const AppTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3a693b),
      surfaceTint: Color(0xff3a693b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbbf0b6),
      onPrimaryContainer: Color(0xff002105),
      secondary: Color(0xff52634f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd5e8cf),
      onSecondaryContainer: Color(0xff101f10),
      tertiary: Color(0xff39656b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcebf1),
      onTertiaryContainer: Color(0xff001f23),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff181d17),
      onSurfaceVariant: Color(0xff424940),
      outline: Color(0xff72796f),
      outlineVariant: Color(0xffc2c9bd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff9fd49b),
      primaryFixed: Color(0xffbbf0b6),
      onPrimaryFixed: Color(0xff002105),
      primaryFixedDim: Color(0xff9fd49b),
      onPrimaryFixedVariant: Color(0xff215025),
      secondaryFixed: Color(0xffd5e8cf),
      onSecondaryFixed: Color(0xff101f10),
      secondaryFixedDim: Color(0xffb9ccb4),
      onSecondaryFixedVariant: Color(0xff3b4b39),
      tertiaryFixed: Color(0xffbcebf1),
      onTertiaryFixed: Color(0xff001f23),
      tertiaryFixedDim: Color(0xffa1ced5),
      onTertiaryFixedVariant: Color(0xff1f4d53),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1d4c22),
      surfaceTint: Color(0xff3a693b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f804f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff374735),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff687965),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1a494f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4f7c82),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff181d17),
      onSurfaceVariant: Color(0xff3e453c),
      outline: Color(0xff5a6158),
      outlineVariant: Color(0xff767d73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff9fd49b),
      primaryFixed: Color(0xff4f804f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff376639),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff687965),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff50604d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4f7c82),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff366368),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002908),
      surfaceTint: Color(0xff3a693b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1d4c22),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff172616),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff374735),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00272b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1a494f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f261e),
      outline: Color(0xff3e453c),
      outlineVariant: Color(0xff3e453c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffc4fabf),
      primaryFixed: Color(0xff1d4c22),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff02350d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff374735),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff213020),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1a494f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003237),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9fd49b),
      surfaceTint: Color(0xff9fd49b),
      onPrimary: Color(0xff073911),
      primaryContainer: Color(0xff215025),
      onPrimaryContainer: Color(0xffbbf0b6),
      secondary: Color(0xffb9ccb4),
      onSecondary: Color(0xff253424),
      secondaryContainer: Color(0xff3b4b39),
      onSecondaryContainer: Color(0xffd5e8cf),
      tertiary: Color(0xffa1ced5),
      onTertiary: Color(0xff00363c),
      tertiaryContainer: Color(0xff1f4d53),
      onTertiaryContainer: Color(0xffbcebf1),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff10140f),
      onSurface: Color(0xffe0e4db),
      onSurfaceVariant: Color(0xffc2c9bd),
      outline: Color(0xff8c9388),
      outlineVariant: Color(0xff424940),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff3a693b),
      primaryFixed: Color(0xffbbf0b6),
      onPrimaryFixed: Color(0xff002105),
      primaryFixedDim: Color(0xff9fd49b),
      onPrimaryFixedVariant: Color(0xff215025),
      secondaryFixed: Color(0xffd5e8cf),
      onSecondaryFixed: Color(0xff101f10),
      secondaryFixedDim: Color(0xffb9ccb4),
      onSecondaryFixedVariant: Color(0xff3b4b39),
      tertiaryFixed: Color(0xffbcebf1),
      onTertiaryFixed: Color(0xff001f23),
      tertiaryFixedDim: Color(0xffa1ced5),
      onTertiaryFixedVariant: Color(0xff1f4d53),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff181d17),
      surfaceContainer: Color(0xff1c211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa3d89f),
      surfaceTint: Color(0xff9fd49b),
      onPrimary: Color(0xff001b04),
      primaryContainer: Color(0xff6b9d69),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbdd0b8),
      onSecondary: Color(0xff0b1a0b),
      secondaryContainer: Color(0xff849680),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa5d3d9),
      onTertiary: Color(0xff001a1d),
      tertiaryContainer: Color(0xff6b989e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10140f),
      onSurface: Color(0xfff8fcf3),
      onSurfaceVariant: Color(0xffc6cdc1),
      outline: Color(0xff9ea59a),
      outlineVariant: Color(0xff7e857b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff235126),
      primaryFixed: Color(0xffbbf0b6),
      onPrimaryFixed: Color(0xff001603),
      primaryFixedDim: Color(0xff9fd49b),
      onPrimaryFixedVariant: Color(0xff0e3f16),
      secondaryFixed: Color(0xffd5e8cf),
      onSecondaryFixed: Color(0xff061407),
      secondaryFixedDim: Color(0xffb9ccb4),
      onSecondaryFixedVariant: Color(0xff2a3a29),
      tertiaryFixed: Color(0xffbcebf1),
      onTertiaryFixed: Color(0xff001417),
      tertiaryFixedDim: Color(0xffa1ced5),
      onTertiaryFixedVariant: Color(0xff083c42),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff181d17),
      surfaceContainer: Color(0xff1c211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff1ffea),
      surfaceTint: Color(0xff9fd49b),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa3d89f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff1ffea),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbdd0b8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff0fdff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa5d3d9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff6fdf1),
      outline: Color(0xffc6cdc1),
      outlineVariant: Color(0xffc6cdc1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff00320b),
      primaryFixed: Color(0xffbff5ba),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa3d89f),
      onPrimaryFixedVariant: Color(0xff001b04),
      secondaryFixed: Color(0xffd9ecd3),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbdd0b8),
      onSecondaryFixedVariant: Color(0xff0b1a0b),
      tertiaryFixed: Color(0xffc0eff6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa5d3d9),
      onTertiaryFixedVariant: Color(0xff001a1d),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff181d17),
      surfaceContainer: Color(0xff1c211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
