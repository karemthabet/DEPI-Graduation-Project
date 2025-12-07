import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_storage/get_storage.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitial(_getSavedLocale()));

  static Locale _getSavedLocale() {
    final storage = GetStorage();
    final String? langCode = storage.read('locale');
    if (langCode != null) {
      return Locale(langCode);
    }
    return const Locale('en'); // Default
  }

  void changeLocale(Locale locale) {
    GetStorage().write('locale', locale.languageCode);
    emit(LocaleChanged(locale));
  }
}
