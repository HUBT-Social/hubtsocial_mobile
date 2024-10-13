import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/style/app_font.dart';
import 'package:hubtsocial_mobile/src/core/style/app_theme.dart';

import '../navigation/router.dart';
import 'di.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    return DI(
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          TextTheme textTheme =
              AppFont.createTextTheme(context, "Roboto", "Roboto");
          AppTheme theme = AppTheme(textTheme);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            // locale: L10n.vi,
            themeMode: ThemeMode.system,
            theme: theme.light(),
            darkTheme: theme.dark(),
            highContrastTheme: theme.lightHighContrast(),
            highContrastDarkTheme: theme.darkHighContrast(),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
