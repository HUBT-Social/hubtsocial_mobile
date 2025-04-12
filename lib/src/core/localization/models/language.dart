import 'dart:ui';

import '../../../constants/assets.dart';
// import '../../gen/assets.gen.dart';

enum Language {
  en(
    Locale('en'),
    Assets.localizationEn,
    'English',
  ),
  ja(
    Locale('ja'),
    Assets.localizationJa,
    '日本語',
  ),
  ko(
    Locale('ko'),
    Assets.localizationKo,
    '한국어',
  ),
  ru(
    Locale('ru'),
    Assets.localizationRu,
    'Русский',
  ),
  vi(
    Locale('vi'),
    Assets.localizationVi,
    'Tiếng Việt',
  ),
  zh(
    Locale('zh'),
    Assets.localizationZh,
    '中文',
  ),
  ;

  const Language(this.value, this.image, this.text);

  final Locale value;
  final String image;
  final String text;
}
