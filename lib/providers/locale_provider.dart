import 'package:disaster_ready/generated/l10n.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  LocaleProvider(this._locale);

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (locale == _locale) return;
    if (!S.delegate.supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  // void clearLocale() {
  //   _locale = null;
  //   notifyListeners();
  // }
}
