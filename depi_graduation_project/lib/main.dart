import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlacesCubit(repository: getIt())),
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
