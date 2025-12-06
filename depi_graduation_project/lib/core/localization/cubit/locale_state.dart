part of 'locale_cubit.dart';

@immutable
sealed class LocaleState {}

final class LocaleInitial extends LocaleState {
  final Locale locale;
  LocaleInitial(this.locale);
}

final class LocaleChanged extends LocaleState {
  final Locale locale;
  LocaleChanged(this.locale);
}
