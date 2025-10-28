import 'package:flutter/material.dart';
import 'app_initializer.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppInitializer.init();
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('فشل تشغيل التطبيق: $e\n$stackTrace');
    rethrow;
  }
}
