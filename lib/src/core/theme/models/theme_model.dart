import 'package:flutter/material.dart';

import '../../configs/assets.dart';
// import '../../gen/assets.gen.dart';

enum ThemeModel {
  system(
    ThemeMode.system,
    Assets.themeSystem,
    'System',
  ),
  light(
    ThemeMode.light,
    Assets.themeLight,
    'Light',
  ),
  dark(
    ThemeMode.dark,
    Assets.themeDark,
    'Dark',
  );

  const ThemeModel(this.value, this.image, this.text);

  final ThemeMode value;
  final String image;
  final String text;
}
