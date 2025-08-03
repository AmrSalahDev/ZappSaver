import '../repositories/language_repository.dart';

class ChangeLanguageUseCase {
  final LanguageRepository repository;

  ChangeLanguageUseCase(this.repository);

  Future<void> call(String code) async {
    await repository.changeLanguage(code);
  }
}
