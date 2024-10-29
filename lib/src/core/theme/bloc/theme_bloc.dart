import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';

import '../models/theme_model.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, AppThemeState> {
  ThemeBloc() : super(const AppThemeState()) {
    on<ChangeTheme>(onChangeTheme);
    on<GetTheme>(onGetTheme);
  }

  onChangeTheme(ChangeTheme event, Emitter<AppThemeState> emit) async {
    AppLocalStorage.update(
        LocalStorageKey.themePrefs, event.selectedTheme.value.toString());
    emit(state.copyWith(selectedTheme: event.selectedTheme));
  }

  onGetTheme(GetTheme event, Emitter<AppThemeState> emit) async {
    final themeCode = AppLocalStorage.get(LocalStorageKey.themePrefs);
    emit(state.copyWith(
      selectedTheme: themeCode != null
          ? ThemeModel.values.firstWhere(
              (item) => item.value.toString() == themeCode,
              orElse: () => _selectedDefaultTheme())
          : _selectedDefaultTheme(),
    ));
  }

  ThemeModel _selectedDefaultTheme() {
    ThemeModel theme = ThemeModel.system;
    AppLocalStorage.update(LocalStorageKey.themePrefs, theme.value);
    return theme;
  }
}
