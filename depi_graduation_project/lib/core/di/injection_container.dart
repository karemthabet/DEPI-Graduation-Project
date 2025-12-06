import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/visit_Screen/data/datasources/visit_remote_datasource.dart';
import '../../features/visit_Screen/data/datasources/visit_remote_datasource_impl.dart';
import '../../features/visit_Screen/data/repositories/visit_repository_impl.dart';
import '../../features/visit_Screen/domain/repositories/visit_repository.dart';
import '../../features/visit_Screen/presentation/cubit/visit_cubit.dart';

final sl = GetIt.instance;

Future<void> initGetIt() async {
  // Cubit
  sl.registerFactory(() => VisitCubit(visitRepository: sl()));

  // Repository
  sl.registerLazySingleton<VisitRepository>(
    () => VisitRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<VisitRemoteDataSource>(
    () => VisitRemoteDataSourceImpl(supabase: sl()),
  );

  // External
  // Assuming Supabase is already initialized in main.dart, we just register the client
  sl.registerLazySingleton(() => Supabase.instance.client);
}
