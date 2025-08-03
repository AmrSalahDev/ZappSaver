abstract class LanguageRepository {
  Future<void> changeLanguage(String code);
  Future<String?> getSavedLanguage();
}
