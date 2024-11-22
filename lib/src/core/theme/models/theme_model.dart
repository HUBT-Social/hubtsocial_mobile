import 'package:flutter/material.dart';

import '../../configs/assets.dart';
// import '../../gen/assets.gen.dart';

enum ThemeModel {
  system(
    ThemeMode.system,
    Assets.themeSystem,
  ),
  light(
    ThemeMode.light,
    Assets.themeLight,
  ),
  dark(
    ThemeMode.dark,
    Assets.themeDark,
  );

  const ThemeModel(this.value, this.image);

  final ThemeMode value;
  final String image;
}
