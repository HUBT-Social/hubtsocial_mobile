import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/theme/bloc/theme_bloc.dart';
import 'package:provider/provider.dart';

import '../localization/bloc/localization_bloc.dart';
import 'providers/user_provider.dart';

class DI extends StatelessWidget {
  const DI({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: _BlocDI(
        child: child,
      ),
    );
  }
}

class _BlocDI extends StatelessWidget {
  const _BlocDI({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocalizationBloc()..add(GetLanguage()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc()..add(GetTheme()),
        ),
      ],
      child: child,
    );
  }
}
