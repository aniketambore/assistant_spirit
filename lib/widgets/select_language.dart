import 'package:flutter/material.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class SelectLanguage extends StatefulWidget {
  SelectLanguage({Key key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Languages"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: RadioSettingsTile(
            settingKey: 'radiokey',
            title: 'Select language',
            values: {
              'af': 'Afrikaans',
              'sq': 'Albanian',
              'ar': 'Arabic',
              'az': 'Azerbaijani',
              'eu': 'Basque',
              'be': 'Belorussian',
              'bn': 'Bengali',
              'bg': 'Bulgarian',
              'ca': 'Catalan',
              'zh-CN': 'Chinese',
              'hr': 'Croatian',
              'cs': 'Czech',
              'da': 'Danish',
              'nl': 'Dutch',
              'en': 'English',
              'eo': 'Esperanto',
              'et': 'Estonian',
              'tl': 'Filipino',
              'fi': 'Finnish',
              'fr': 'French',
              'gl': 'Galician',
              'ka': 'Georgian',
              'de': 'German',
              'el': 'Greek',
              'gu': 'Gujarati',
              'ht': 'Haitian Creole',
              'iw': 'Hebrew',
              'hi': 'Hindi',
              'hu': 'Hungarian',
              'is': 'Icelandic',
              'id': 'Indonesian',
              'ga': 'Irish',
              'it': 'Italian',
              'ja': 'Japanese',
              'kn': 'Kannada',
              'ko': 'Korean',
              'la': 'Latin',
              'lv': 'Latvian',
              'lt': 'Lithuanian',
              'mr': 'Marathi',
              'mk': 'Macedonian',
              'ms': 'Malay',
              'mt': 'Maltese',
              'no': 'Norwegian',
              'fa': 'Persian',
              'pl': 'Polish',
              'pt': 'Portuguese',
              'ro': 'Romanian',
              'ru': 'Russian',
              'sr': 'Serbian',
              'sk': 'Slovak',
              'sl': 'Slovenian',
              'es': 'Spanish',
              'sw': 'Swahili',
              'sv': 'Swedish',
              'ta': 'Tamil',
              'te': 'Telugu',
              'th': 'Thai',
              'tr': 'Turkish',
              'uk': 'Ukrainian',
              'ur': 'Urdu',
              'vi': 'Vietnamese',
              'cy': 'Welsh',
              'yi': 'Yiddish'
            },
          ),
        ),
      ),
    );
  }
}
