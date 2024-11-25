import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/style/app_font.dart';
import 'package:hubtsocial_mobile/src/core/style/app_theme.dart';
import 'package:provider/provider.dart';

import '../localization/bloc/localization_bloc.dart';
import '../navigation/router.import.dart';
import '../theme/bloc/theme_bloc.dart';

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
      splitScreenMode: true,
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      ensureScreenSize: true,
      builder: (context, child) {
        TextTheme textTheme =
            AppFont.createTextTheme(context, "Roboto", "Roboto");
        AppTheme theme = AppTheme(textTheme);
        return MultiBlocProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            BlocProvider(
              create: (context) => LocalizationBloc()..add(GetLanguage()),
            ),
            BlocProvider(
              create: (context) => ThemeBloc()..add(GetTheme()),
            ),
          ],
          child: BlocBuilder<LocalizationBloc, AppLocalizationState>(
            builder: (context, stateLocalization) {
              return BlocBuilder<ThemeBloc, AppThemeState>(
                builder: (context, stateTheme) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    //Theme
                    themeMode: stateTheme.selectedTheme.value,
                    theme: theme.light(),
                    darkTheme: theme.dark(),
                    highContrastTheme: theme.lightHighContrast(),
                    highContrastDarkTheme: theme.darkHighContrast(),
                    //Localizations
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    locale: stateLocalization.selectedLanguage.value,
                    //Router
                    routerConfig: router,
                    // routerDelegate: router.routerDelegate,
                    // routeInformationParser: router.routeInformationParser,
                    // routeInformationProvider: router.routeInformationProvider,
                    builder: FlutterSmartDialog.init(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
