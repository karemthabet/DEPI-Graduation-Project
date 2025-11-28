// In main.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/core/utils/constants/supabase_constants.dart';
import 'package:whatsapp/features/home/data/models/cached_place_details_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/my_app.dart';
import 'features/home/data/models/cached_places_model.dart';
import 'features/home/data/models/place_model.dart';
import 'features/home/data/models/cached_location_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register all Hive adapters
  Hive.registerAdapter(CachedPlacesModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(OpeningHoursAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  Hive.registerAdapter(CachedLocationModelAdapter());
  // Register the location adapter
  Hive.registerAdapter(CachedPlaceDetailsModelAdapter());

  // Open the box
  await Hive.openBox<CachedPlaceDetailsModel>('place_details_cache');

  // Open Hive boxes
  await Hive.openBox<CachedPlacesModel>('places_cache');
  await Hive.openBox<CachedLocationModel>(
    'location_cache',
  ); // Open location box

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  // Initialize Supabase here
  await Supabase.initialize(
    url: 'https://uztrxupjubheaxxagzyd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6dHJ4dXBqdWJoZWF4eGFnenlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyMTc0NjksImV4cCI6MjA3ODc5MzQ2OX0.GDcTRLVFM_i0m9LMDhAR3z97JzM4bZj0FQdKpfiuZTQ',
  );

  // Setup service locator dependencies
  setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlacesCubit(repository: getIt())),
        BlocProvider(create: (context) => PlaceDetailsCubit(getIt())),
        BlocProvider(create: (context) => UserCubit(getIt())),
      ],
      child: const MyApp(),
    ),
  );
}
