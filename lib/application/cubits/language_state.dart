import '../../features/select_lang/domain/entities/language_entity.dart';

abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageChanged extends LanguageState {
  final LanguageEntity locale;

  LanguageChanged(this.locale);
}
