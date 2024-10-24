import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/style/app_font.dart';
import 'package:hubtsocial_mobile/src/core/style/app_theme.dart';

import '../localization/bloc/localization_bloc.dart';
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

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        TextTheme textTheme =
            AppFont.createTextTheme(context, "Roboto", "Roboto");
        AppTheme theme = AppTheme(textTheme);
        return BlocProvider(
          create: (context) => LocalizationBloc()..add(GetLanguage()),
          child: BlocBuilder<LocalizationBloc, AppLocalizationState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                //Theme
                themeMode: ThemeMode.system,
                theme: theme.light(),
                darkTheme: theme.dark(),
                highContrastTheme: theme.lightHighContrast(),
                highContrastDarkTheme: theme.darkHighContrast(),
                //Localizations
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                locale: state.selectedLanguage.value,
                //Router
                routerConfig: router,
                // routerDelegate: router.routerDelegate,
                // routeInformationParser: router.routeInformationParser,
                // routeInformationProvider: router.routeInformationProvider,
              );
            },
          ),
        );
      },
    );
  }
}
