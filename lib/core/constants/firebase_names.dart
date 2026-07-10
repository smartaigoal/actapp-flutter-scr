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
