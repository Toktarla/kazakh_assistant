import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocalizedValueResolver {
  /// Returns the localized version of the field based on the current context.
  /// Pass in the values for each language, it returns the matching one or fallback.
  static String? resolve({
    required BuildContext context,
    String? kz,
    String? ru,
    String? en,
  }) {
    final languageCode = context.locale.languageCode;

    switch (languageCode) {
      case 'kk':
        return kz ?? ru ?? en;
      case 'ru':
        return ru ?? kz ?? en;
      case 'en':
      default:
        return en ?? ru ?? kz;
    }
  }

  static List<String>? resolveList({
    required BuildContext context,
    List<String>? kz,
    List<String>? ru,
    List<String>? en,
  }) {
    final languageCode = context.locale.languageCode;

    switch (languageCode) {
      case 'kk':
        return kz ?? ru ?? en;
      case 'ru':
        return ru ?? kz ?? en;
      case 'en':
      default:
        return en ?? ru ?? kz;
    }
  }

  static T? resolveGeneric<T>({
    required BuildContext context,
    T? kz,
    T? ru,
    T? en,
  }) {
    final languageCode = context.locale.languageCode;

    switch (languageCode) {
      case 'kk':
        return kz ?? ru ?? en;
      case 'ru':
        return ru ?? kz ?? en;
      case 'en':
      default:
        return en ?? ru ?? kz;
    }
  }

  static List<String> generateCategoryList(BuildContext context) {
    final languageCode = context.locale.languageCode;

    switch (languageCode) {
      case 'kk':
        return ['Табыс', 'Өмір', 'Жұмыс', 'Махаббат'];
      case 'ru':
        return ['Успех', 'Жизнь', 'Работа', 'Любовь'];
      case 'en':
      default:
        return ['Success', 'Life', 'Work', 'Love'];
    }
  }
}
