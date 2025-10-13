import 'package:flutter/material.dart';
import 'package:whatsapp/my_app.dart';
import 'package:whatsapp/app_initializer.dart';

void main() async {
  try {
    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize app services
    await AppInitializer.init();

    // Run the app with ScreenUtil for responsive design
    runApp(  const MyApp());
  } catch (e, stackTrace) {
    // Handle any initialization errors
    debugPrint('فشل تشغيل التطبيق: $e\n$stackTrace');
    rethrow;
  }
}
