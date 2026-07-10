import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/localization/app_translations.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Guide App',
      translations: AppTranslations(),
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
