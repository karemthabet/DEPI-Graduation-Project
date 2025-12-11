import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp/core/services/google_maps_place_service.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/core/utils/constants/supabase_constants.dart';
import 'package:whatsapp/core/utils/router/app_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/FavouriteScreen/data/models/repositories/favourite_repository_impl.dart';
import 'package:whatsapp/features/FavouriteScreen/data/models/repositories/favourites_repository.dart';
import 'package:whatsapp/features/FavouriteScreen/presentation/cubit/favourite_cubit.dart';
import 'package:whatsapp/features/home/data/models/cached_place_details_model.dart';
import 'package:whatsapp/features/home/data/models/cached_places_model.dart';
import 'package:whatsapp/features/home/data/models/cached_location_model.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';
import 'package:whatsapp/features/home/data/repositories/search_repository.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/search_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/models/search_cache_model.dart';
import 'package:whatsapp/supabase_service.dart';
import 'package:whatsapp/core/services/notification_service.dart';
import 'package:whatsapp/features/visit_Screen/presentation/cubit/visit_cubit.dart';
import 'package:whatsapp/core/localization/cubit/locale_cubit.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import 'package:whatsapp/features/login/presentation/cubit/auth_cubit.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CachedPlacesModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(OpeningHoursAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  Hive.registerAdapter(CachedLocationModelAdapter());
  Hive.registerAdapter(CachedPlaceDetailsModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(SearchCacheModelAdapter());

  // Open Hive boxes
  await Hive.openBox<CachedPlaceDetailsModel>('place_details_cache');
  await Hive.openBox<CachedPlacesModel>('places_cache');
  await Hive.openBox<CachedLocationModel>('location_cache');
  await Hive.openBox<UserModel>('user_cache');
  await Hive.openBox<SearchCacheModel>('prediction_cache');

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  await SupabaseService.initialize();

  // ⬇️ إضافة Auth State Listener للـ Deep Link
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    final session = data.session;

    if (event == AuthChangeEvent.signedIn && session != null) {
      print('✅ User signed in: ${session.user.email}');
      print('✅ Email confirmed: ${session.user.emailConfirmedAt != null}');
    } else if (event == AuthChangeEvent.passwordRecovery) {
      print('Password Recovery Event Detected');
      AppRouter.router.push(RoutesName.updatePassword);
    }
  });

  setupServiceLocator();
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
          BlocProvider(create: (context) => UserCubit(getIt())),
          BlocProvider(create: (context) => getIt<VisitCubit>()),
          BlocProvider(create: (context) => LocaleCubit()),
          BlocProvider<FavoritesCubit>(
            create: (context) => FavoritesCubit(
              repository: context.read<IFavoritesRepository>(),
            )..loadFavorites(),
          ),
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(
            create: (_) => SearchCubit(
              SearchRepository(
                GoogleMapsPlaceService(),
                Hive.box<SearchCacheModel>('prediction_cache'),
                Hive.box<CachedPlaceDetailsModel>('place_details_cache'),
              ),
            ),
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
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            Locale? locale;
            if (state is LocaleChanged) {
              locale = state.locale;
            } else if (state is LocaleInitial) {
              locale = state.locale;
            }

            return MaterialApp.router(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}
