import 'package:flutter/material.dart';

class RSSLocalizations {
  RSSLocalizations(this.locale);

  final Locale locale;

  static RSSLocalizations of(BuildContext context) {
    return Localizations.of<RSSLocalizations>(context, RSSLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'RSS Feed',
      'loadingMessage': 'Loading Feed...',
      'feedLoadErrorMessage': 'Error Loading Feed',
      'newspaper': 'Select newspaper',
      'fontSize': 'Font Size',
      'backToTop': 'Back to top'
    },
    'ko': {
      'title': 'RSS Feed',
      'loadingMessage': '불러오는 중...',
      'feedLoadErrorMessage': '불러오기 실패',
      'newspaper': '신문사 선택',
      'fontSize': '글자 크기',
      'backToTop': '맨 위로'
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get loadingMessage {
    return _localizedValues[locale.languageCode]['loadingMessage'];
  }

  String get feedLoadErrorMessage {
    return _localizedValues[locale.languageCode]['feedLoadErrorMessage'];
  }

  String get newspaper {
    return _localizedValues[locale.languageCode]['newspaper'];
  }

  String get fontSize {
    return _localizedValues[locale.languageCode]['fontSize'];
  }

  String get backToTop {
    return _localizedValues[locale.languageCode]['backToTop'];
  }
}
