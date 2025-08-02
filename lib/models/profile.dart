import 'dart:ui';

import 'package:vocaber/models/appconfig.dart';

class Profile {
  static String? getUsername() {
    return AppConfig().prefs.getString('username');
  }

  static String? getProfileImageUrl() {
    return AppConfig().prefs.getString('profileImageUrl');
  }

  static String getPreferredLanguage() {
    final savedLanguage = AppConfig().prefs.getString('language');

    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      return savedLanguage;
    }

    return PlatformDispatcher.instance.locale.languageCode;
  }

  static void save(String username, String imageUrl, String language) {
    final prefs = AppConfig().prefs;
    prefs.setString('username', username);
    prefs.setString('profileImageUrl', imageUrl);
    prefs.setString('language', language);
  }

  static bool isProfileComplete() {
    final name = getUsername();
    final image = getProfileImageUrl();
    return name != null && image != null;
  }

  static String generateAvatarUrl(String name) {
    return 'https://api.dicebear.com/9.x/pixel-art/png?seed=$name';
  }
}
