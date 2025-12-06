import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitial(const Locale('en'))); // Default to English

  void changeLocale(Locale locale) {
    emit(LocaleChanged(locale));
  }
}
