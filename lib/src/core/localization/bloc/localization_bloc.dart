import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:language_code/language_code.dart';

import '../models/language.dart';

part 'localization_event.dart';
part 'localization_state.dart';

const languagePrefsKey = 'languagePrefs';

class LocalizationBloc extends Bloc<LocalizationEvent, AppLocalizationState> {
  LocalizationBloc() : super(const AppLocalizationState()) {
    on<ChangeLanguage>(onChangeLanguage);
    on<GetLanguage>(onGetLanguage);
  }

  onChangeLanguage(
      ChangeLanguage event, Emitter<AppLocalizationState> emit) async {
    AppLocalStorage.update(LocalStorageKey.languagePrefs,
        event.selectedLanguage.value.languageCode);
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  onGetLanguage(GetLanguage event, Emitter<AppLocalizationState> emit) async {
    emit(state.copyWith(
      selectedLanguage: AppLocalStorage.languageCode != null
          ? Language.values.firstWhere(
              (item) => item.value.languageCode == AppLocalStorage.languageCode,
              orElse: () => _selectedDefaultLanguage())
          : _selectedDefaultLanguage(),
    ));
  }

  Language _selectedDefaultLanguage() {
    Language language = Language.values.firstWhere(
        (item) =>
            item.value.languageCode == LanguageCode.code.locale.languageCode,
        orElse: () => Language.english);
    AppLocalStorage.update(
        LocalStorageKey.languagePrefs, language.value.languageCode);
    return language;
  }
}
