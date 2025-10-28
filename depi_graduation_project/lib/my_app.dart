import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/router/app_router.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'WhatsApp',
          debugShowCheckedModeBanner: false,
          // Fix: use textScaleFactor to control system font scaling
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                devicePixelRatio: ScreenUtil().pixelRatio,
                textScaleFactor: 1.0,
              ),
              child: widget ?? const SizedBox.shrink(),
            );
          },
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
