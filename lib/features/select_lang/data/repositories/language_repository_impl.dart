import 'package:flutter_status_up/features/select_lang/domain/repositories/language_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepositoryImpl extends LanguageRepository {
  static const _key = 'selected_locale';

  @override
  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }

  @override
  Future<String?> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    return code ?? 'en';
  }
}
