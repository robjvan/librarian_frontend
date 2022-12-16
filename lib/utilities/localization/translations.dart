import 'package:get/get.dart';
import 'package:librarian_frontend/utilities/localization/en.dart';
import 'package:librarian_frontend/utilities/localization/es.dart';
import 'package:librarian_frontend/utilities/localization/fr.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en': englishStrings,
        'fr': frenchStrings,
        'es': spanishStrings,
      };
}
