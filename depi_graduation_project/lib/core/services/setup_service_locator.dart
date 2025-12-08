import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core
import 'package:whatsapp/core/services/api_service.dart';
import 'package:whatsapp/core/services/dio_consumer.dart';

// Home Feature
import 'package:whatsapp/features/home/data/data_sources/places_local_data_source.dart';
import 'package:whatsapp/features/home/data/data_sources/places_remote_data_source.dart';
import 'package:whatsapp/features/home/data/repositories/places_repository.dart';
import 'package:whatsapp/features/home/data/repositories/places_repository_impl.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';

// Profile Feature
import 'package:whatsapp/core/services/supabase_service.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository_impl.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';

// Visit Feature
import 'package:whatsapp/features/visit_Screen/data/datasources/visit_remote_datasource.dart';
import 'package:whatsapp/features/visit_Screen/data/datasources/visit_remote_datasource_impl.dart';
import 'package:whatsapp/features/visit_Screen/data/repositories/visit_repository_impl.dart';
import 'package:whatsapp/features/visit_Screen/domain/repositories/visit_repository.dart';
import 'package:whatsapp/features/visit_Screen/presentation/cubit/visit_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ================= Core Services =================
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiService>(() => DioConsumer(dio: getIt<Dio>()));

  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // ================= Data Sources =================

  getIt.registerLazySingleton<PlacesLocalDataSource>(
    () => PlacesLocalDataSource(),
  );

  getIt.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSource(apiService: getIt<ApiService>()),
  );

  // ================= Repository =================
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(
      localDataSource: getIt<PlacesLocalDataSource>(),
      remoteDataSource: getIt<PlacesRemoteDataSource>(),
    ),
  );

  // ================= User Repository =================
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<SupabaseService>()),
  );

  // ================= Cubits =================
  getIt.registerFactory(
    () => PlacesCubit(repository: getIt<PlacesRepository>()),
  );

  getIt.registerFactory(() => UserCubit(getIt<UserRepository>()));

  // ================= Visit Feature =================
  getIt.registerLazySingleton<VisitRemoteDataSource>(
    () => VisitRemoteDataSourceImpl(supabase: Supabase.instance.client),
  );

  getIt.registerLazySingleton<VisitRepository>(
    () => VisitRepositoryImpl(remoteDataSource: getIt<VisitRemoteDataSource>()),
  );

  getIt.registerFactory(() => VisitCubit(
    visitRepository: getIt<VisitRepository>(),
    userRepository: getIt<UserRepository>(),
  ));
}
