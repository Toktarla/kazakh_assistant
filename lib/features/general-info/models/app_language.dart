import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { kk, ru, en }

extension AppLanguageExtension on AppLanguage {
  String get sttLocaleId {
    switch (this) {
      case AppLanguage.kk:
        return 'kk-KZ';
      case AppLanguage.ru:
        return 'ru-RU';
      case AppLanguage.en:
        return 'en-EN';
    }
  }


  static AppLanguage fromLocaleCode(String code) {
    switch (code.toLowerCase()) {
      case 'kk':
        return AppLanguage.kk;
      case 'ru':
        return AppLanguage.ru;
      case 'en':
      default:
        return AppLanguage.en;
    }
  }
}

extension SttLocaleContext on BuildContext {
  String get sttLocaleId {
    final langCode = locale.languageCode;
    final appLang = AppLanguageExtension.fromLocaleCode(langCode);
    return appLang.sttLocaleId;
  }

  String getTargetLanguage(BuildContext context) {
    switch (context.locale.languageCode) {
      case 'kk':
        return 'Kazakh';
      case 'ru':
        return 'Russian';
      case 'en':
      default:
        return 'English';
    }
  }
}

class Prefs {
  static const _keySttDialogShown = 'stt_caution_shown';

  static Future<bool> isSttDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySttDialogShown) ?? false;
  }

  static Future<void> setSttDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySttDialogShown, true);
  }
}
