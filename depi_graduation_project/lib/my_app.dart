import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
          designSize: const Size(390, 844), 
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (_, child) {
            return MaterialApp.router(
              title: 'WhatsApp',
              debugShowCheckedModeBanner: false,
              builder: (context, widget) {
                // Set text scale factor to 1.0 to prevent system font scaling
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    devicePixelRatio: ScreenUtil().pixelRatio, textScaler: const TextScaler.linear(1.0),
                  ),
                  child: widget!,
                );
              },
              routerConfig:AppRouter.router,
            );
          },
        );
  }
}
