import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:rss_feed/rss_localizations.dart';

class RSSLocalizationsDelegate extends LocalizationsDelegate<RSSLocalizations> {
  const RSSLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<RSSLocalizations> load(Locale locale) {
    return SynchronousFuture<RSSLocalizations>(RSSLocalizations(locale));
  }

  @override
  bool shouldReload(RSSLocalizationsDelegate old) => false;
}
