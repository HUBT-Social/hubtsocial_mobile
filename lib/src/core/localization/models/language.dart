import 'dart:ui';

import '../../configs/assets.dart';
// import '../../gen/assets.gen.dart';

enum Language {
  english(
    Locale('en', 'US'),
    Assets.localizationEn,
    'English',
  ),
  vi(
    Locale('vi', 'VI'),
    Assets.localizationVi,
    'Tiếng Việt',
  );

  const Language(this.value, this.image, this.text);

  final Locale value;
  final String image;
  final String text;
}
