import 'package:flutter_status_up/features/select_lang/domain/repositories/language_repository.dart';

class GetSavedLangUsecase {
  final LanguageRepository repository;

  GetSavedLangUsecase(this.repository);

  Future<String?> call() async {
    return await repository.getSavedLanguage();
  }
}
