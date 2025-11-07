import 'package:flutter/material.dart';
import 'app_initializer.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppInitializer.init();

    // Run the app with ScreenUtil for responsive design
    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Handle any initialization errors
    debugPrint('فشل                   تشغيل التطبيق: $e\n$stackTrace');
    runApp(const MyApp());
  } 
}
