import 'package:get/get.dart';
import 'messages_ar.dart';
import 'messages_en.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': messagesAr,
    'en': messagesEn,
  };
}
