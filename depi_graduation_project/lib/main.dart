// // In main.dart
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:whatsapp/core/services/setup_service_locator.dart';
// <<<<<<< HEAD
// import 'package:whatsapp/core/utils/constants/supabase_constants.dart';
// import 'package:whatsapp/features/home/data/models/cached_place_details_model.dart';
// import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
// import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
// import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
// import 'package:whatsapp/my_app.dart';
// import 'features/home/data/models/cached_places_model.dart';
// import 'features/home/data/models/place_model.dart';
// import 'features/home/data/models/cached_location_model.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();

//   // Register all Hive adapters
//   Hive.registerAdapter(CachedPlacesModelAdapter());
//   Hive.registerAdapter(PlaceModelAdapter());
//   Hive.registerAdapter(OpeningHoursAdapter());
//   Hive.registerAdapter(ReviewModelAdapter());
//   Hive.registerAdapter(CachedLocationModelAdapter());
//   // Register the location adapter
//   Hive.registerAdapter(CachedPlaceDetailsModelAdapter());

//   // Open the box
//   await Hive.openBox<CachedPlaceDetailsModel>('place_details_cache');

//   // Open Hive boxes
//   await Hive.openBox<CachedPlacesModel>('places_cache');
//   await Hive.openBox<CachedLocationModel>(
//     'location_cache',
//   ); // Open location box

//   await Supabase.initialize(
//     url: SupabaseConstants.supabaseUrl,
//     anonKey: SupabaseConstants.supabaseAnonKey,
//   );

//   // Setup service locator dependencies
// =======
// import 'package:whatsapp/core/utils/router/app_router.dart';
// import 'package:whatsapp/features/FavouriteScreen/data/models/repositories/favourite_repository_impl.dart';
// import 'package:whatsapp/features/FavouriteScreen/presentation/cubit/favourite_cubit.dart';
// import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
// import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
// import 'package:whatsapp/supabase_service.dart';

// import 'features/FavouriteScreen/data/models/repositories/favourites_repository.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SupabaseService.initialize();
// >>>>>>> feature/favorite-logic
//   setupServiceLocator();

//   runApp(
//     MultiRepositoryProvider(
//       providers: [
// <<<<<<< HEAD
//         BlocProvider(create: (context) => PlacesCubit(repository: getIt())),
//         BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
//         BlocProvider(create: (context) => UserCubit(getIt())),
// =======
//         RepositoryProvider<IFavoritesRepository>(
//           create: (_) => FavoritesRepositoryImpl(),
//         ),
// >>>>>>> feature/favorite-logic
//       ],

//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (context) => PlacesCubit(getIt())),
//           BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
//           BlocProvider<FavoritesCubit>(
//             create: (context) => FavoritesCubit(
//               repository: context.read<IFavoritesRepository>(),
//               userId: '22222222-2222-2222-2222-222222222222',
//             )..loadFavorites(),
//           ),
//         ],
//         child: const MyApp(),
//       ),
//     ),
//   );
// }
// <<<<<<< HEAD
// =======

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       builder: (context, child) {
//         return MaterialApp.router(
//           debugShowCheckedModeBanner: false,
//           routerConfig: AppRouter.router,
//         );
//       },
//     );
//   }
// }
// >>>>>>> feature/favorite-logic
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
import 'package:whatsapp/core/services/setup_service_locator.dart';

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
          BlocProvider(create: (context) => UserCubit(getIt())),
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
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
