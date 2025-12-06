import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/core/utils/constants/supabase_constants.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';
import 'package:whatsapp/features/FavouriteScreen/data/models/repositories/favourite_repository_impl.dart';
import 'package:whatsapp/features/FavouriteScreen/data/models/repositories/favourites_repository.dart';
import 'package:whatsapp/features/FavouriteScreen/presentation/cubit/favourite_cubit.dart';
import 'package:whatsapp/features/home/data/models/cached_place_details_model.dart';
import 'package:whatsapp/features/home/data/models/cached_places_model.dart';
import 'package:whatsapp/features/home/data/models/cached_location_model.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/supabase_service.dart';
import 'package:whatsapp/my_app.dart';
import 'package:whatsapp/core/services/notification_service.dart';
import 'package:whatsapp/features/visit_Screen/presentation/cubit/visit_cubit.dart';
import 'package:whatsapp/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CachedPlacesModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(OpeningHoursAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  Hive.registerAdapter(CachedLocationModelAdapter());
  Hive.registerAdapter(CachedPlaceDetailsModelAdapter());

  // Open Hive boxes
  await Hive.openBox<CachedPlaceDetailsModel>('place_details_cache');
  await Hive.openBox<CachedPlacesModel>('places_cache');
  await Hive.openBox<CachedLocationModel>('location_cache');

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  await SupabaseService.initialize();

  // Setup service locator
  setupServiceLocator();
  await di.initGetIt();
  await NotificationService().init();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IFavoritesRepository>(
          create: (_) => FavoritesRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PlacesCubit(repository: getIt())),
          BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
          BlocProvider(
            create: (context) => UserCubit(getIt())..loadUserProfile(),
          ),

          BlocProvider(create: (context) => UserCubit(getIt())),
          BlocProvider(create: (context) => di.sl<VisitCubit>()),
          BlocProvider<FavoritesCubit>(
            create: (context) => FavoritesCubit(
              repository: context.read<IFavoritesRepository>(),
              userId: SupabaseService.userId,
            )..loadFavorites(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
