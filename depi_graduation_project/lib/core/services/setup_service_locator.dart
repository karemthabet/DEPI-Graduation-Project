import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp/core/services/api_service.dart';
import 'package:whatsapp/core/services/dio_consumer.dart';
import 'package:whatsapp/features/home/data/repositories/places_repository.dart';
import 'package:whatsapp/features/home/data/repositories/places_repository_impl.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';

/// ✅ Global GetIt instance
final getIt = GetIt.instance;

/// ✅ Setup Service Locator
/// Call this function in `main()`
/// Example:
///   setupServiceLocator();
///   runApp(MyApp());
void setupServiceLocator() {
  // --- Core services ---
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => DioConsumer(dio: getIt<Dio>()));
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(apiService: getIt<ApiService>()),
  );
 getIt.registerFactory(() => PlacesCubit(repository:  getIt<PlacesRepository>()));
}

/// Example:
///   final api = sl<ApiService>();
T sl<T extends Object>() => getIt<T>();

/* ===============================
   📌 Usage Examples

1. Initialization in main():
--------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(MyApp());
}

2. Accessing registered services:
--------------------------------
final dio = sl<Dio>();
final api = sl<ApiService>();

3. Registering custom services:
--------------------------------
getIt.registerLazySingleton<AuthRepo>(
  () => AuthRepoImpl(apiService: sl<ApiService>()),
);

getIt.registerFactory(() => AuthCubit(sl<AuthRepo>()));

4. Using inside Cubit/Bloc:
--------------------------------
class MyCubit extends Cubit<MyState> {
  final AuthRepo authRepo;
  MyCubit(this.authRepo) : super(MyInitial());
}

final myCubit = sl<MyCubit>();
*/
