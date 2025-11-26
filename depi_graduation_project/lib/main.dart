import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';

import 'package:whatsapp/core/utils/constants/supabase_constants.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/home/data/models/cached_places_model.dart';
import 'features/home/data/models/place_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CachedPlacesModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(OpeningHoursAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  await Hive.openBox<CachedPlacesModel>('places_cache');
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  setupServiceLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlacesCubit(getIt())),
        BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
        BlocProvider(create: (context) => UserCubit(getIt())),
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
