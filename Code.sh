# إنشاء جميع المجلدات المطلوبة
mkdir -p lib/core/{constants,services,helpers,network,theme,widgets,localization,firebase}
mkdir -p lib/models
mkdir -p lib/repositories/abstract lib/repositories/concrete
mkdir -p lib/controllers
mkdir -p lib/routes
mkdir -p lib/features/splash lib/features/auth lib/features/home lib/features/places lib/features/ads lib/features/profile lib/features/settings lib/features/search
mkdir -p firebase

# 1) Core services (المتبقي)
cat > lib/core/services/messaging_service.dart <<'EOF'
// lib/core/services/messaging_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> getToken() => _messaging.getToken();

  Future<void> requestPermission() async {
    await _messaging.requestPermission();
  }

  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
}
EOF

cat > lib/core/services/analytics_service.dart <<'EOF'
// lib/core/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }
}
EOF

cat > lib/core/services/crashlytics_service.dart <<'EOF'
// lib/core/services/crashlytics_service.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> recordError(Object exception, StackTrace stack) {
    _crashlytics.recordError(exception, stack);
    return Future.value();
  }

  Future<void> setUserIdentifier(String id) {
    return _crashlytics.setUserIdentifier(id);
  }
}
EOF

cat > lib/core/services/dynamic_links_service.dart <<'EOF'
// lib/core/services/dynamic_links_service.dart
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksService {
  final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  Future<PendingDynamicLinkData?> getInitialLink() => _dynamicLinks.getInitialLink();

  Stream<PendingDynamicLinkData> get onLink => _dynamicLinks.onLink;
}
EOF

cat > lib/core/services/location_service.dart <<'EOF'
// lib/core/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> isLocationEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
EOF

# 2) Helpers
cat > lib/core/helpers/network_helper.dart <<'EOF'
// lib/core/helpers/network_helper.dart
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
EOF

cat > lib/core/helpers/permission_helper.dart <<'EOF'
// lib/core/helpers/permission_helper.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }
}
EOF

cat > lib/core/helpers/validation_helper.dart <<'EOF'
// lib/core/helpers/validation_helper.dart
class ValidationHelper {
  static bool isPhoneValid(String phone) {
    return phone.isNotEmpty && phone.length >= 6;
  }

  static bool isNotEmpty(String value) => value.trim().isNotEmpty;
}
EOF

# 3) Network
cat > lib/core/network/dio_client.dart <<'EOF'
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
}
EOF

cat > lib/core/network/api_exception.dart <<'EOF'
// lib/core/network/api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException(code: \$code, message: \$message)';
}
EOF

# 4) Theme
cat > lib/core/theme/app_theme.dart <<'EOF'
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  static ThemeData light = LightTheme.lightTheme;
  static ThemeData dark = DarkTheme.darkTheme;
}
EOF

cat > lib/core/theme/light_theme.dart <<'EOF'
// lib/core/theme/light_theme.dart
import 'package:flutter/material.dart';

class LightTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );
}
EOF

cat > lib/core/theme/dark_theme.dart <<'EOF'
// lib/core/theme/dark_theme.dart
import 'package:flutter/material.dart';

class DarkTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );
}
EOF

# 5) Widgets (basic, functional)
cat > lib/core/widgets/custom_button.dart <<'EOF'
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomButton({required this.onPressed, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
EOF

cat > lib/core/widgets/custom_text_field.dart <<'EOF'
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const CustomTextField({required this.controller, this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller, decoration: InputDecoration(hintText: hintText));
  }
}
EOF

cat > lib/core/widgets/shimmer_loading.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.white, height: 100),
    );
  }
}
EOF

cat > lib/core/widgets/error_widget.dart <<'EOF'
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  const AppErrorWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(color: Colors.red)));
  }
}
EOF

cat > lib/core/widgets/loading_widget.dart <<'EOF'
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
EOF

cat > lib/core/widgets/image_cached.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCached extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ImageCached({required this.url, this.fit = BoxFit.cover, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl: url, fit: fit, placeholder: (_, __) => const SizedBox(), errorWidget: (_, __, ___) => const Icon(Icons.error));
  }
}
EOF

# 6) Localization
cat > lib/core/localization/app_translations.dart <<'EOF'
// lib/core/localization/app_translations.dart
import 'package:get/get.dart';
import 'messages_en.dart';
import 'messages_ar.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': MessagesEn.messages,
        'ar': MessagesAr.messages,
      };
}
EOF

cat > lib/core/localization/messages_en.dart <<'EOF'
// lib/core/localization/messages_en.dart
class MessagesEn {
  static const Map<String, String> messages = {
    'app_title': 'My Guide App',
    'login': 'Login',
    'otp': 'OTP',
  };
}
EOF

cat > lib/core/localization/messages_ar.dart <<'EOF'
 // lib/core/localization/messages_ar.dart
class MessagesAr {
  static const Map<String, String> messages = {
    'app_title': 'تطبيقي',
    'login': 'تسجيل الدخول',
    'otp': 'رمز التحقق',
  };
}
EOF

# 7) Repositories abstract (interfaces)
cat > lib/repositories/abstract/i_ad_repository.dart <<'EOF'
// lib/repositories/abstract/i_ad_repository.dart
import 'package:my_guide_app/models/ad_model.dart';

abstract class IAdRepository {
  Stream<List<AdModel>> getAdsStream();
  Future<List<AdModel>> getCachedAds();
  Future<void> cacheAds(List<AdModel> ads);
}
EOF

cat > lib/repositories/abstract/i_tab_repository.dart <<'EOF'
// lib/repositories/abstract/i_tab_repository.dart
import 'package:my_guide_app/models/tab_model.dart';

abstract class ITabRepository {
  Stream<List<TabModel>> getTabsStream();
  Future<List<TabModel>> getCachedTabs();
  Future<void> cacheTabs(List<TabModel> tabs);
}
EOF

cat > lib/repositories/abstract/i_category_repository.dart <<'EOF'
// lib/repositories/abstract/i_category_repository.dart
import 'package:my_guide_app/models/category_model.dart';

abstract class ICategoryRepository {
  Stream<List<CategoryModel>> getCategoriesStream();
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
}
EOF

cat > lib/repositories/abstract/i_user_repository.dart <<'EOF'
// lib/repositories/abstract/i_user_repository.dart
import 'package:my_guide_app/models/setting_model.dart';
import 'package:my_guide_app/models/setting_model.dart' as sm;

abstract class IUserRepository {
  Future<sm.SettingModel?> getUser(String id);
  Future<void> createUser(dynamic user);
  Future<void> updateLastLogin(String id);
}
EOF

# 8) Repositories concrete (basic implementations analogous to place_repository)
cat > lib/repositories/concrete/ad_repository.dart <<'EOF'
// lib/repositories/concrete/ad_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_guide_app/core/constants/firebase_names.dart';
import 'package:my_guide_app/core/helpers/cache_helper.dart';
import 'package:my_guide_app/core/services/firestore_service.dart';
import 'package:my_guide_app/models/ad_model.dart';
import 'package:my_guide_app/repositories/abstract/i_ad_repository.dart';

class AdRepository implements IAdRepository {
  final FirestoreService _firestore;

  AdRepository(this._firestore);

  @override
  Stream<List<AdModel>> getAdsStream() {
    return _firestore.streamCollection(FirestoreNames.collectionAds, orderBy: FirestoreNames.fieldAdOrder).map((snapshot) {
      final ads = snapshot.docs.map((d) => AdModel.fromFirestore(d)).toList();
      CacheHelper.savePlaces([]); // noop for structure consistency
      return ads;
    });
  }

  @override
  Future<List<AdModel>> getCachedAds() async {
    return []; // minimal: return empty list
  }

  @override
  Future<void> cacheAds(List<AdModel> ads) async {
    // minimal
  }
}
EOF

cat > lib/repositories/concrete/tab_repository.dart <<'EOF'
// lib/repositories/concrete/tab_repository.dart
import 'package:my_guide_app/core/services/firestore_service.dart';
import 'package:my_guide_app/models/tab_model.dart';
import 'package:my_guide_app/core/constants/firebase_names.dart';
import 'package:my_guide_app/core/helpers/cache_helper.dart';

class TabRepository {
  final FirestoreService _firestore;
  TabRepository(this._firestore);

  Stream<List<TabModel>> getTabsStream() {
    return _firestore.streamCollection(FirestoreNames.collectionTabs, orderBy: FirestoreNames.fieldTabOrder).map((snap) {
      return snap.docs.map((d) => TabModel.fromJson(d.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<List<TabModel>> getCachedTabs() async => [];

  Future<void> cacheTabs(List<TabModel> tabs) async {}
}
EOF

cat > lib/repositories/concrete/category_repository.dart <<'EOF'
 // lib/repositories/concrete/category_repository.dart
import 'package:my_guide_app/core/services/firestore_service.dart';
import 'package:my_guide_app/models/category_model.dart';
import 'package:my_guide_app/core/constants/firebase_names.dart';

class CategoryRepository {
  final FirestoreService _firestore;
  CategoryRepository(this._firestore);

  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestore.streamCollection(FirestoreNames.collectionCategories).map((snap) {
      return snap.docs.map((d) => CategoryModel.fromJson(d.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<List<CategoryModel>> getCachedCategories() async => [];

  Future<void> cacheCategories(List<CategoryModel> categories) async {}
}
EOF

cat > lib/repositories/concrete/user_repository.dart <<'EOF'
 // lib/repositories/concrete/user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_guide_app/core/constants/firebase_names.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getUserDoc(String id) async {
    final doc = await _firestore.collection(FirestoreNames.collectionUsers).doc(id).get();
    return doc.exists ? doc : null;
  }

  Future<void> createUser(Map<String, dynamic> data) {
    return _firestore.collection(FirestoreNames.collectionUsers).doc(data['id']).set(data);
  }

  Future<void> updateLastLogin(String id) {
    return _firestore.collection(FirestoreNames.collectionUsers).doc(id).update({FirestoreNames.fieldLastLogin: DateTime.now().toIso8601String()});
  }
}
EOF

# 9) Controllers remaining
cat > lib/controllers/ad_controller.dart <<'EOF'
 // lib/controllers/ad_controller.dart
import 'package:get/get.dart';
import 'package:my_guide_app/models/ad_model.dart';

class AdController extends GetxController {
  final RxList<AdModel> ads = <AdModel>[].obs;
  final RxBool isLoading = false.obs;
}
EOF

cat > lib/controllers/settings_controller.dart <<'EOF'
 // lib/controllers/settings_controller.dart
import 'package:get/get.dart';
import 'package:my_guide_app/models/setting_model.dart';

class SettingsController extends GetxController {
  final RxList<SettingModel> settings = <SettingModel>[].obs;
}
EOF

cat > lib/controllers/app_controller.dart <<'EOF'
 // lib/controllers/app_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('en').obs;
}
EOF

# 10) Routes
cat > lib/routes/app_routes.dart <<'EOF'
 // lib/routes/app_routes.dart
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const otp = '/otp';
  static const home = '/home';
}
EOF

cat > lib/routes/app_pages.dart <<'EOF'
 // lib/routes/app_pages.dart
import 'package:get/get.dart';
import 'app_routes.dart';
import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/home/home_screen.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.otp, page: () => const OtpScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
  ];
}
EOF

cat > lib/routes/route_middleware.dart <<'EOF'
 // lib/routes/route_middleware.dart
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // minimal implementation: allow all
    return null;
  }
}
EOF

# 11) Features: splash
cat > lib/features/splash/splash_screen.dart <<'EOF'
 // lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Splash')));
  }
}
EOF

cat > lib/features/splash/splash_controller.dart <<'EOF'
 // lib/features/splash/splash_controller.dart
import 'package:get/get.dart';

class SplashController extends GetxController {}
EOF

cat > lib/features/splash/splash_binding.dart <<'EOF'
 // lib/features/splash/splash_binding.dart
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
EOF

# 12) Features: auth (screens and binding)
cat > lib/features/auth/login_screen.dart <<'EOF'
 // lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    final phoneController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: phoneController),
          ElevatedButton(onPressed: () => c.sendOtp(phoneController.text), child: const Text('Send OTP')),
        ]),
      ),
    );
  }
}
EOF

cat > lib/features/auth/otp_screen.dart <<'EOF'
 // lib/features/auth/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    final code = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: code),
          ElevatedButton(onPressed: () => c.verifyOtp(code.text), child: const Text('Verify')),
        ]),
      ),
    );
  }
}
EOF

cat > lib/features/auth/auth_binding.dart <<'EOF'
 // lib/features/auth/auth_binding.dart
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
EOF

# 13) Features: home (screen + binding)
cat > lib/features/home/home_screen.dart <<'EOF'
 // lib/features/home/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Home')), body: Center(child: Text('Home')));
  }
}
EOF

cat > lib/features/home/home_binding.dart <<'EOF'
 // lib/features/home/home_binding.dart
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
EOF

# 14) Features: places (screens + binding)
cat > lib/features/places/add_place_screen.dart <<'EOF'
 // lib/features/places/add_place_screen.dart
import 'package:flutter/material.dart';

class AddPlaceScreen extends StatelessWidget {
  const AddPlaceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Add Place')), body: Center(child: Text('Add Place')));
  }
}
EOF

cat > lib/features/places/place_details_screen.dart <<'EOF'
 // lib/features/places/place_details_screen.dart
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Place Details')), body: Center(child: Text('Details')));
  }
}
EOF

cat > lib/features/places/places_list_screen.dart <<'EOF'
 // lib/features/places/places_list_screen.dart
import 'package:flutter/material.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Places')), body: Center(child: Text('List')));
  }
}
EOF

cat > lib/features/places/place_binding.dart <<'EOF'
 // lib/features/places/place_binding.dart
import 'package:get/get.dart';
import '../../controllers/place_controller.dart';

class PlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlaceController());
  }
}
EOF

# 15) Features: ads
cat > lib/features/ads/ads_screen.dart <<'EOF'
 // lib/features/ads/ads_screen.dart
import 'package:flutter/material.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Ads')), body: Center(child: Text('Ads')));
  }
}
EOF

cat > lib/features/ads/ads_binding.dart <<'EOF'
 // lib/features/ads/ads_binding.dart
import 'package:get/get.dart';
import '../../controllers/ad_controller.dart';

class AdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdController());
  }
}
EOF

# 16) Features: profile
cat > lib/features/profile/profile_screen.dart <<'EOF'
 // lib/features/profile/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Profile')), body: Center(child: Text('Profile')));
  }
}
EOF

cat > lib/features/profile/profile_binding.dart <<'EOF'
 // lib/features/profile/profile_binding.dart
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {}
}
EOF

# 17) Features: settings
cat > lib/features/settings/settings_screen.dart <<'EOF'
 // lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Settings')), body: Center(child: Text('Settings')));
  }
}
EOF

cat > lib/features/settings/settings_binding.dart <<'EOF'
 // lib/features/settings/settings_binding.dart
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}
EOF

# 18) Features: search
cat > lib/features/search/search_screen.dart <<'EOF'
 // lib/features/search/search_screen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: AppBar(title: Text('Search')), body: Center(child: Text('Search')));
  }
}
EOF

cat > lib/features/search/search_binding.dart <<'EOF'
 // lib/features/search/search_binding.dart
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {}
}
EOF

# 19) Firebase rules/indexes placeholders (left minimal as architect.md requires generation/real data)
cat > firebase/firestore.rules <<'EOF'
/* Firestore rules placeholder: generate/replace with real rules for your project */
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
EOF

cat > firebase/storage.rules <<'EOF'
/* Storage rules placeholder: replace with real rules */
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
EOF

cat > firebase/firestore.indexes.json <<'EOF'
{
  "indexes": [],
  "fieldOverrides": []
}
EOF

# 20) firebase_options.dart: create a note file indicating generation (no fake data)
cat > lib/firebase/firebase_options.dart <<'EOF'
/*
  firebase_options.dart must be generated by the FlutterFire CLI for your Firebase project.
  Do not add fake credentials here. Run:
    flutterfire configure
  to generate this file with real project values.
*/
EOF

# 21) Final commit and push
git add -A
git commit -m "Complete project structure per architect.md (generate remaining files and skeletons)"
git push origin HEAD
