import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/features/select_lang/data/models/language_model.dart';
import 'package:flutter_status_up/features/select_lang/domain/entities/language_entity.dart';
import 'package:flutter_status_up/features/select_lang/domain/usecases/chanage_language_usecase.dart';
import 'package:flutter_status_up/features/select_lang/domain/usecases/get_saved_lang_usecase.dart';

import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final ChangeLanguageUseCase changeLanguageUseCase;
  final GetSavedLangUsecase getSavedLangUsecase;

  LanguageCubit(this.changeLanguageUseCase, this.getSavedLangUsecase)
    : super(LanguageInitial()) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final savedCode = await getSavedLangUsecase();
    final selectedLang = LanguageModel.supportedLanguages.firstWhere(
      (lang) => lang.code == savedCode,
      orElse: () => LanguageModel(code: 'en', name: 'English', flag: 'us'),
    );

    emit(LanguageChanged(selectedLang));
  }

  Future<void> changeLanguage(LanguageEntity language) async {
    await changeLanguageUseCase(language.code);
    emit(LanguageChanged(language));
  }
}
