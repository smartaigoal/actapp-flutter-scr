```markdown
# وثيقة المعمارية الكاملة للمشروع (Single Source of Truth)

ملاحظة تمهيدية:
- هذا الملف هو المرجع الوحيد والمعتمد لبناء المشروع — يجب أن تُنفذ الشيفرة، تسميات الملفات، المجلدات، والتقنيات حرفيًا كما هو مذكور هنا دون تعديل إلّا بتحديث هذا الملف أولًا.
- المشروع مبني على Flutter مع Clean Architecture، إدارة الحالة والتوجيه عبر GetX، وتكامل مع Firebase (Auth, Firestore, Storage, Messaging, Analytics, Crashlytics, Remote Config, Dynamic Links, App Check) مع تخزين محلي عبر Hive.
- أي ملف تهيئة أو مفتاح خارجي (firebase_options.dart, google-services.json, GoogleService-Info.plist, API keys) لا يُدرَج بقيم مزيفة؛ تُولَّد أو تُوضع محليًا عبر أدواتك (FlutterFire CLI أو إعدادات المنصة).

---
## 1. نظرة عامة على البنية (Project Structure)

المجلدات والملفات الأساسية (كل الملفات والحقائب التي يجب أن توجد في `lib/`):

```
lib/
├── main.dart
├── app.dart
├── firebase/firebase_options.dart           # يُولَّد محلياً عبر FlutterFire CLI
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── firebase_names.dart
│   │   └── endpoints.dart
│   ├── firebase/
│   │   └── firebase_initializer.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── storage_service.dart
│   │   ├── messaging_service.dart
│   │   ├── analytics_service.dart
│   │   ├── crashlytics_service.dart
│   │   ├── remote_config_service.dart
│   │   ├── dynamic_links_service.dart
│   │   ├── connectivity_service.dart
│   │   └── location_service.dart
│   ├── helpers/
│   │   ├── network_helper.dart
│   │   ├── cache_helper.dart
│   │   ├── permission_helper.dart
│   │   └── validation_helper.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── api_exception.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── shimmer_loading.dart
│   │   ├── error_widget.dart
│   │   ├── loading_widget.dart
│   │   └── image_cached.dart
│   ├── localization/
│   │   ├── app_translations.dart
│   │   ├── messages_ar.dart
│   │   └── messages_en.dart
│   └── utils/
│       ├── logger.dart
│       ├── validators.dart
│       └── extensions.dart
├── features/
│   ├── splash/
│   │   ├── splash_screen.dart
│   │   ├── splash_controller.dart
│   │   └── splash_binding.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   ├── auth_controller.dart
│   │   └── auth_binding.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── home_controller.dart
│   │   └── home_binding.dart
│   ├── places/
│   │   ├── add_place_screen.dart
│   │   ├── place_details_screen.dart
│   │   ├── places_list_screen.dart
│   │   ├── place_controller.dart
│   │   └── place_binding.dart
│   ├── ads/
│   │   ├── ads_screen.dart
│   │   ├── ads_controller.dart
│   │   └── ads_binding.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── profile_controller.dart
│   │   └── profile_binding.dart
│   ├── settings/
│   │   ├── settings_screen.dart
│   │   ├── settings_controller.dart
│   │   └── settings_binding.dart
│   └── search/
│       ├── search_screen.dart
│       ├── search_controller.dart
│       └── search_binding.dart
├── models/
│   ├── place_model.dart
│   ├── place_model.g.dart
│   ├── ad_model.dart
│   ├── ad_model.g.dart
│   ├── tab_model.dart
│   ├── tab_model.g.dart
│   ├── category_model.dart
│   ├── category_model.g.dart
│   ├── user_model.dart
│   ├── user_model.g.dart
│   ├── setting_model.dart
│   ├── setting_model.g.dart
│   ├── notification_model.dart
│   └── notification_model.g.dart
├── repositories/
│   ├── abstract/
│   │   ├── i_place_repository.dart
│   │   ├── i_ad_repository.dart
│   │   ├── i_tab_repository.dart
│   │   ├── i_category_repository.dart
│   │   └── i_user_repository.dart
│   └── concrete/
│       ├── place_repository.dart
│       ├── ad_repository.dart
│       ├── tab_repository.dart
│       ├── category_repository.dart
│       └── user_repository.dart
├── controllers/
│   ├── auth_controller.dart
│   ├── home_controller.dart
│   ├── place_controller.dart
│   ├── ad_controller.dart
│   ├── settings_controller.dart
│   └── app_controller.dart
├── routes/
│   ├── app_pages.dart
│   ├── app_routes.dart
│   └── route_middleware.dart
├── generated/
│   └── (flutter_gen / json_serializable outputs)
└── firebase/
    ├── firestore.rules
    ├── storage.rules
    └── firestore.indexes.json
```

---
## 2. pubspec.yaml (اعتمادات المشروع)
استعمل بالضبط المحتويات التالية (نسخ حرفي):

```yaml
name: my_guide_app
description: تطبيق دليل الأماكن والإعلانات

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # Core
  get: ^4.6.5
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.5.0
  firebase_messaging: ^14.7.0
  firebase_analytics: ^10.7.0
  firebase_crashlytics: ^3.4.0
  firebase_remote_config: ^4.3.0
  firebase_dynamic_links: ^5.4.0
  firebase_app_check: ^0.2.0

  # UI
  flutter_svg: ^2.0.7
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  flutter_rating_bar: ^4.0.1
  fluttertoast: ^8.2.4

  # Storage
  hive_flutter: ^1.1.0
  path_provider: ^2.1.0

  # Networking
  connectivity_plus: ^5.0.1
  dio: ^5.3.2
  retrofit: ^4.0.1

  # Utils
  equatable: ^2.0.5
  intl: ^0.18.1
  url_launcher: ^6.2.0
  share_plus: ^7.2.1
  image_picker: ^1.0.0
  permission_handler: ^11.0.1
  flutter_native_splash: ^2.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
  retrofit_generator: ^7.0.5
  hive_generator: ^2.0.1
  flutter_gen_runner: ^5.4.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - assets/translations/
```

---
## 3. الثوابت (firebase_names.dart)

انسخ هذا الملف حرفيًا — يحتوي أسماء المجموعات والحقول المستخدمة في Firestore وStorage وRemote Config keys:

```dart
// lib/core/constants/firebase_names.dart

class FirestoreNames {
  // Collections
  static const String collectionUsers = 'المستخدمين';
  static const String collectionAds = 'الإعلانات';
  static const String collectionSettings = 'الإعدادات';
  static const String collectionTabs = 'التبويبات';
  static const String collectionPlaces = 'الأماكن';
  static const String collectionCategories = 'الفئات';
  static const String collectionCities = 'المدن';
  static const String collectionOffers = 'العروض';
  static const String collectionNotifications = 'الإشعارات';
  static const String collectionVersions = 'الإصدارات';

  // Fields - Users
  static const String fieldName = 'الاسم';
  static const String fieldPhone = 'رقم الهاتف';
  static const String fieldPhoto = 'الصورة';
  static const String fieldEmail = 'البريد الإلكتروني';
  static const String fieldCreatedAt = 'تاريخ الإنشاء';
  static const String fieldLastLogin = 'آخر دخول';
  static const String fieldIsActive = 'نشط';

  // Fields - Places
  static const String fieldPlaceName = 'الاسم';
  static const String fieldDescription = 'الوصف';
  static const String fieldLatitude = 'خط العرض';
  static const String fieldLongitude = 'خط الطول';
  static const String fieldLocation = 'الموقع';
  static const String fieldCategory = 'الفئة';
  static const String fieldCategoryId = 'معرف الفئة';
  static const String fieldOwner = 'المالك';
  static const String fieldOwnerId = 'معرف المالك';
  static const String fieldImages = 'الصور';
  static const String fieldPhoneNumbers = 'أرقام التواصل';
  static const String fieldNotes = 'ملاحظات';
  static const String fieldViews = 'عدد الزيارات';
  static const String fieldIsApproved = 'موافق عليه';
  static const String fieldCreatedDate = 'التاريخ';
  static const String fieldUpdatedAt = 'آخر تحديث';
  static const String fieldVisible = 'ظاهر';
  static const String fieldOrder = 'الترتيب';
  static const String fieldRating = 'التقييم';

  // Ads
  static const String fieldAdImage = 'الصورة';
  static const String fieldAdLink = 'الرابط';
  static const String fieldAdOrder = 'الترتيب';
  static const String fieldAdStatus = 'الحالة';
  static const String fieldAdDuration = 'مدة الظهور';

  // Tabs
  static const String fieldTabName = 'الاسم';
  static const String fieldTabImage = 'الصورة';
  static const String fieldTabOrder = 'الترتيب';
  static const String fieldTabActive = 'مفعل';

  // Settings
  static const String fieldSettingKey = 'المفتاح';
  static const String fieldSettingValue = 'القيمة';
  static const String fieldSettingType = 'النوع';

  // Remote Config keys
  static const String rcDefaultTabCount = 'default_tab_count';
  static const String rcShowAds = 'show_ads';
  static const String rcHideSection = 'hide_section';
  static const String rcEnablePage = 'enable_page';
  static const String rcSupportNumber = 'support_number';
  static const String rcPrivacyPolicy = 'privacy_policy';
  static const String rcForceUpdate = 'force_update';
  static const String rcMaintenanceMessage = 'maintenance_message';
  static const String rcShowAppRating = 'show_app_rating';

  // Storage paths
  static const String storagePlaces = 'places/';
  static const String storageUsers = 'users/';
  static const String storageAds = 'ads/';
  static const String storageTabs = 'tabs/';
}
```

---
## 4. النماذج (Models)
جميع النماذج تستخدم `equatable` و `json_serializable` وتوفّر `copyWith` و `fromFirestore`:

- place_model.dart (مثال كامل في `lib/models/place_model.dart` في المستودع)
- ad_model.dart
- tab_model.dart
- category_model.dart
- user_model.dart
- setting_model.dart
- notification_model.dart

المطلوب: احتفظ بملفات `.g.dart` الناتجة (يمكن توليدها عبر build_runner) أو ضَع نسخها المولدة في المستودع (كما نفَّذنا سابقًا) لتجنّب الحاجة لتشغيل build_runner في وقت البناء.

ملاحظة حول `fromFirestore(DocumentSnapshot doc)`:
- افتراض أن مستند Firestore يحتوي قيمًا قابلة للتحويل إلى JSON القياسي؛ إن كانت الحقول عبارة عن `Timestamp` فاحرص على تحويلها إلى `DateTime` أثناء `fromJson`.

---
## 5. الخدمات (Services)

تفصيل خدمات الأساسية وواجه interfaces:

5.1 Firebase Initializer
- ملف: lib/core/firebase/firebase_initializer.dart
- مسؤول عن: Firebase.initializeApp(), تهيئة App Check (في الإنتاج)، ربط Crashlytics بمصادر الأخطاء، واستدعاء RemoteConfigService.init().

5.2 AuthService (lib/core/services/auth_service.dart)
- وظائف:
  - userChanges stream
  - sendOtp(String phoneNumber, Function(String) onCodeSent)
  - verifyOtp(String verificationId, String smsCode)
  - signOut()
  - getCurrentUserId(), getCurrentUserPhone()

5.3 FirestoreService (lib/core/services/firestore_service.dart)
- وظائف:
  - getDocument(collectionPath, docId)
  - streamCollection(collectionPath, {orderBy, descending=false, filters})
  - addDocument(collectionPath, data)
  - updateDocument(collectionPath, docId, data)
  - deleteDocument(collectionPath, docId)
- QueryFilter class: يحمل الحقل وقيمته (الحزمة تستخدمه لبناء where queries).

5.4 StorageService (lib/core/services/storage_service.dart)
- وظائف: uploadFile(path, File), deleteFile(path)

5.5 MessagingService (firebase_messaging)
- وظائف: الحصول على token، الطلب إذونات الإشعارات، stream onMessage.

5.6 AnalyticsService (firebase_analytics)
- لوج الأحداث المهيكلة.

5.7 CrashlyticsService
- تسجيل الأخطاء، تعيين معرف المستخدم.

5.8 RemoteConfigService
- fetchAndActivate + setDefaults.

5.9 DynamicLinksService
- الحصول على initial link و الاستماع للروابط الواردة.

5.10 ConnectivityService
- isConnected() و onConnectivityChanged stream.

5.11 LocationService
- استخدام geolocator: checkPermission(), isLocationEnabled(), getCurrentPosition().

ملاحظة: كل الخدمات يجب أن تستخدم الـ Firebase SDK المناسبة، ويجب أن لا تفترض وجود firebase_options.dart — البلاغة هنا: الملف موجود كهيكل ويُولّد محليًا.

---
## 6. التخزين المحلي (Cache / Hive)

- ملف: lib/core/helpers/cache_helper.dart
- ما يقوم به:
  - Hive.initFlutter()
  - تسجيل TypeAdapters لكل نموذج (PlaceModelAdapter, AdModelAdapter, TabModelAdapter, CategoryModelAdapter, SettingModelAdapter, UserModelAdapter, NotificationModelAdapter)
  - فتح الصناديق (boxes) المسماة: placesBox, adsBox, tabsBox, categoriesBox, settingsBox
  - وظائف: savePlaces, getPlaces, getPlace (ومثيلاتها للإعلانات/التبويبات/الفئات/الإعدادات)

ملاحظة: توليد adapters يُمكن أن يتم عبر hive_generator (build_runner) أو إدراج adapters مولدة ضمن المستودع — المطلوب ضمن هذه الوثيقة هو وجود adapters مسجلة في CacheHelper.init().

---
## 7. المستودعات (Repositories)

اتباع طبقة Abstract / Concrete:

- Abstract interfaces (lib/repositories/abstract/*.dart):
  - IPlaceRepository
  - IAdRepository
  - ITabRepository
  - ICategoryRepository
  - IUserRepository

- Concrete implementations في lib/repositories/concrete/*.dart يجب أن تعتمد على FirestoreService و StorageService و ConnectivityService و CacheHelper حيث يلزم.

مثال واجهات بسيطة وطرق متوقعة:
- getPlacesStream({String? categoryId})
- getCachedPlaces()
- cachePlaces(List<PlaceModel>)
- addPlace(PlaceModel place, List<String> imageFiles)
- updatePlace(PlaceModel)
- deletePlace(String id)

المستودعات التنفيذية:
- PlaceRepository: يستخدم FirestoreService.streamCollection مع QueryFilters، يرفع الصور إلى Firebase Storage عبر StorageService، يقوم بسياسة مزامنة مع CacheHelper عندما يكون هناك اتصال.
- AdRepository, TabRepository, CategoryRepository: نمط مشابه لقراءة المجموعات، تحويل المستندات إلى موديلات، وتحديث الكاش.

---
## 8. المتحكمات (GetX Controllers)

كل controller يمتد GetxController ويعالج حالة العرض والتعامل مع المستودعات/الخدمات:

8.1 AuthController
- إدارة userChanges من AuthService، إرسال/تحقق OTP، التعامل مع المستخدم في Firestore (IUserRepository).

8.2 HomeController
- تحميل التبويبات والإعلانات: أولًا من الكاش ثم الاستماع للسيرفر إذا متصل.

8.3 PlaceController
- تحميل الفئات والأماكن، دعم إضافة/تحديث/حذف الأماكن بالاستعانة بالمستودع.

8.4 AdController, SettingsController, AppController
- AppController يدير theme/locale/connection عبر observables.

ملاحظات: كل controller يجب أن يعتمد على `Get.find()` للحصول على الـ services/repositories المسجّلة في Binding.

---
## 9. Features (شاشات، bindings، routing)

- لكل feature (splash, auth, home, places, ads, profile, settings, search) توجد:
  - شاشة UI (screen.dart)
  - Controller (controller.dart)
  - Binding (binding.dart) — يسجّل التبعيات عبر Get.put() أو Get.lazyPut()

Routing:
- lib/routes/app_routes.dart: تعريف المسارات الثابتة:
  - '/' (Splash), '/login', '/otp', '/home', '/places/add', '/places/details', '/profile', '/settings', '/search'
- lib/routes/app_pages.dart: قائمة GetPage تربط المسارات بالشاشات والـ bindings
- route_middleware.dart: يمكنك إضافة Authentication middleware التي تحقّق وجود مستخدم مسجّل قبل الوصول لمسارات محمية (ببساطة تعيد null للسماح أو RouteSettings للتحويل).

App bootstrapping:
- main.dart: WidgetsFlutterBinding.ensureInitialized(); await FirebaseInitializer.init(); await CacheHelper.init(); runApp(const App());
- app.dart: GetMaterialApp مع:
  - translations: AppTranslations()
  - locale, fallbackLocale
  - initialRoute: AppRoutes.splash
  - getPages: AppPages.pages
  - theme: AppTheme.light, darkTheme: AppTheme.dark, themeMode من AppController

---
## 10. قواعد Firebase (firebase/)

ملفات في مجلد firebase/:
- firestore.rules — ضع قواعدك الفعلية هنا. في المستودع اترك ملفًا إرشاديًا أو مثالًا بسيطًا مع تحديد سياسة افتراضية صارمة.
- storage.rules — قواعد التخزين.
- firestore.indexes.json — مؤشرات Firestore إذا احتاجت.

هنا مثال بسيط (يُستبدل بالقواعد الحقيقية في بيئتك):
- لا تترك قواعدًا تسمح بالقراءة/الكتابة للجمهور؛ استخدم قواعد تحقق تعتمد على Auth UID أو شروط المشروع.

---
## 11. Generated files و Code Generation
- استخدم `flutter pub run build_runner build --delete-conflicting-outputs` لتوليد ملفات json_serializable (الموجودة كـ part '...g.dart') وHive adapters إن لم يتم إدراجها مسبقًا.
- إذا تم إدراج ملفات `.g.dart` و adapters داخل المستودع فلا حاجة لتشغيل build_runner عند البناء.

---
## 12. التعليمات التشغيلية (Local Setup & Build)

الخطوات الأساسية بعد استنساخ المستودع:

1) تثبيت الحزم:
   - flutter pub get

2) (إن لم يكن موجودًا) توليد firebase_options.dart:
   - قم بإعداد مشروع Firebase
   - ثبت FlutterFire CLI: dart pub global activate flutterfire_cli
   - شغّل: flutterfire configure
   - سيولد lib/firebase/firebase_options.dart ويحدث إعدادات المنصات.

3) (منصة اندرويد/آي أو إس) أضف google-services.json و GoogleService-Info.plist في المواضع المناسبة.

4) (إن لم تُضمّن) توليد ملفات JSON/Hive adapter:
   - flutter pub run build_runner build --delete-conflicting-outputs

5) تهيئة Hive وصناديق التخزين محليًا تتم تلقائيًا عبر CacheHelper.init() (يُنادى منها في main).

6) تحليل وبناء:
   - flutter analyze
   - flutter build apk (أو flutter run)

---
## 13. CI / CD و اختبارات
- أنشئ ملف GitHub Actions بإجراءتين أساسيتين:
  - analyze: تشغيل flutter analyze
  - build: بناء debug apk أو web bundle
- لا تُخزن مفاتيح Firebase في repo — استخدم Secrets في CI لتزويد بيانات البيئة أو استخدم توليد عبر FlutterFire مع متغيرات CI مؤمنة.

---
## 14. الاعتبارات الأمنية وخصوصية البيانات
- لا تحفظ مفاتيح أو ملفات تهيئة في المستودع العام.
- قواعد Firestore وStorage يجب أن تمنع الوصول غير المصرح به.
- عند تخزين معلومات حساسة محليًا استخدام Hive مع تشفير إن لزم.

---
## 15. أمثلة شيفرات أساسية (نقاط مرجعية)

15.1 main.dart (المرجع):
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/firebase/firebase_initializer.dart';
import 'core/helpers/cache_helper.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.init();
  await CacheHelper.init();
  runApp(const App());
}
```

15.2 firebase_initializer.dart (المرجع):
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import '../services/remote_config_service.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    await Firebase.initializeApp();
    if (!kDebugMode) {
      await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity, appleProvider: AppleProvider.appAttest);
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await RemoteConfigService.init();
  }
}
```

15.3 FirestoreService.streaming example:
```dart
Stream<QuerySnapshot> streamCollection(String collectionPath, {String? orderBy, bool descending = false, List<QueryFilter>? filters}) {
  Query query = _firestore.collection(collectionPath);
  if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
  if (filters != null) {
    for (var f in filters) {
      query = query.where(f.field, isEqualTo: f.value);
    }
  }
  return query.snapshots();
}
```

---
## 16. قواعد وقيود التنفيذ (التزام صارم بالمرجع)
- هذا الملف هو المصدر الوحيد للحقيقة (Single Source of Truth). أي تعديل على الهيكل أو تسمية ملف أو تقنية يتطلب تحديث هذا الملف أولًا.
- يمنع إدراج قيم مزيفة أو Placeholder لمفاتيح بيئية أو مفاتيح منصات — احتفظ بالهيكل واترك القيم الحساسة ليتم توليدها محليًا.
- لا تستخدم UnimplementedError أو TODO في الملفات المنشورة النهائية — إما اكتب تنفيذًا مطابقًا للمساحة المتوقعة في الملف، أو اترك الهيكل (وظائف مكتوبة بسلوك افتراضي آمن إن أمكن).

---
## 17. متى يعتبر المشروع "مكتملًا" حسب هذا المرجع
المشروع يُعتبر مكتملًا عندما:
- كل الملفات المذكورة أعلاه موجودة في المستودع وبنفس المسارات والأسماء.
- ملفات النماذج `.g.dart` وHive adapters متاحة أو قابلة للتوليد عبر build_runner بنجاح.
- `lib/firebase/firebase_options.dart` موجود (مُولَّد محليًا عبر FlutterFire) وملفات المنصة اللازمة مُضافة.
- `flutter analyze` يُرجع نتائج بدون أخطاء حاسمة و`flutter build` ينجح (مع مراعاة أن بعض الوظائف قد تتطلب مفاتيح منصات خارجية).

---
## 18. خطوات لاحقة مقترحة (مرجعية)
- ملء القواعد الحقيقية في firebase/firestore.rules وstorage.rules.
- إعداد GitHub Actions للـ analyze و build و الإصدارات.
- إعداد Sentry أو أدوات إضافية للمراقبة إن رغبت.
- تحسين واجهات المستخدم واستبدال شاشات العرض البسيطة بالشاشات النهائية حسب التصميم.

---
انتهت وثيقة المعمارية الكاملة — اعمل على تطبيقها حرفيًا في المستودع، واستعن بهذه الوثيقة كمصدر واحد معتمد لكل قرار هيكلي أو تقني في المشروع.
```