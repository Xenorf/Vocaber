import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocaber/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  late SharedPreferences prefs;

  factory AppConfig() => _instance;

  AppConfig._internal();

  Map<String, String> _supportedLanguages = {'en': 'English'};

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  void localize(BuildContext context) {
    _supportedLanguages = {
      'en': AppLocalizations.of(context)!.english,
      'fr': AppLocalizations.of(context)!.french,
    };
  }

  Map<String, String> get supportedLanguages => _supportedLanguages;
}
