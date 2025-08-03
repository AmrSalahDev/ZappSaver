import 'package:flutter_status_up/features/select_lang/domain/entities/language_entity.dart';

class LanguageModel extends LanguageEntity {
  LanguageModel({
    required super.name,
    required super.code,
    required super.flag,
  });

  static List<LanguageModel> get supportedLanguages => [
    LanguageModel(code: 'en', name: 'English', flag: 'us'),
    LanguageModel(code: 'ar', name: 'العربية', flag: 'eg'),
    LanguageModel(code: 'fr', name: 'Français', flag: 'fr'),
    LanguageModel(code: 'de', name: 'Deutsch', flag: 'de'),
    LanguageModel(code: 'es', name: 'Español', flag: 'es'),
  ];
}
