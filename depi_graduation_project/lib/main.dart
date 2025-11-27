import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp/core/services/notification_service.dart';
import 'package:whatsapp/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await di.initGetIt();
  await NotificationService().init();
  await Supabase.initialize(
    url: 'https://uztrxupjubheaxxagzyd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6dHJ4dXBqdWJoZWF4eGFnenlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyMTc0NjksImV4cCI6MjA3ODc5MzQ2OX0.GDcTRLVFM_i0m9LMDhAR3z97JzM4bZj0FQdKpfiuZTQ',
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlacesCubit(getIt())),
        BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp.router(routerConfig: AppRouter.router);
      },
    );
  }
}
