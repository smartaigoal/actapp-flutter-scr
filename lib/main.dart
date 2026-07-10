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
