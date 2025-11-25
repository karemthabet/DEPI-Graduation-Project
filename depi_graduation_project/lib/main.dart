import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';
import 'package:whatsapp/features/FavouriteScreen/data/models/repositories/favourite_repository_impl.dart';
import 'package:whatsapp/features/FavouriteScreen/presentation/cubit/favourite_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/supabase_service.dart';

import 'features/FavouriteScreen/data/models/repositories/favourites_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
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
          BlocProvider(create: (context) => PlacesCubit(getIt())),
          BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
          BlocProvider<FavoritesCubit>(
            create: (context) => FavoritesCubit(
              repository: context.read<IFavoritesRepository>(),
              userId: '22222222-2222-2222-2222-222222222222',
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
