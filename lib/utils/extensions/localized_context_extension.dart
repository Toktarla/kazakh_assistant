import 'package:flutter/material.dart';
import '../localized_value_resolver.dart';

extension LocalizedString on BuildContext {
  String? localizedValue({String? kz, String? ru, String? en}) {
    return LocalizedValueResolver.resolve(context: this, kz: kz, ru: ru, en: en);
  }

  List<String>? localizedValueList({List<String>? kz, List<String>? ru, List<String>? en}) {
    return LocalizedValueResolver.resolveList(context: this, kz: kz, ru: ru, en: en);
  }

  T? localizedValueGeneric<T>({T? kz, T? ru, T? en}) {
    return LocalizedValueResolver.resolveGeneric(context: this, kz: kz, ru: ru, en: en);
  }

  String detectLanguage(String text) {
    // Check for Kazakh characters
    if (RegExp(r'[әғқңөұүһ]').hasMatch(text)) {
      return 'kk-KZ';
    }
    // Check for Cyrillic (assume Russian)
    if (RegExp(r'[А-Яа-я]').hasMatch(text)) {
      return 'ru-RU';
    }
    // Default to English
    return 'en-US';
  }

}

