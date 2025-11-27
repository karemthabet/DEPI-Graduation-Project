# 🚀 دليل الإعداد السريع | Quick Setup Guide

## خطوات التكامل | Integration Steps

### 1️⃣ تحديث main.dart

أضف تسجيل Adapters الجديدة:

```dart
import 'features/home/data/models/cached_location_model.dart';
import 'features/home/data/models/cached_top_recommendations_model.dart';
import 'features/home/data/models/cached_place_details_model.dart';
import 'features/home/data/models/cached_categories_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Adapters الموجودة مسبقاً
  Hive.registerAdapter(CachedPlacesModelAdapter());
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(OpeningHoursAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  
  // Adapters الجديدة ⭐
  Hive.registerAdapter(CachedLocationModelAdapter());
  Hive.registerAdapter(CachedTopRecommendationsModelAdapter());
  Hive.registerAdapter(CachedPlaceDetailsModelAdapter());
  Hive.registerAdapter(CachedCategoriesModelAdapter());
  
  // لا حاجة لفتح الصناديق هنا - ستُفتح تلقائياً عند الحاجة
  // No need to open boxes here - they'll open automatically when needed
  
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

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
```

---

### 2️⃣ تحديث setup_service_locator.dart

أضف تسجيل Data Sources الجديدة:

```dart
import 'package:whatsapp/features/home/data/data_sources/places_local_data_source.dart';
import 'package:whatsapp/features/home/data/data_sources/places_remote_data_source.dart';

Future<void> setupServiceLocator() async {
  // --- Core services ---
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => DioConsumer(dio: getIt<Dio>()));
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // --- Data Sources (جديد) ⭐ ---
  getIt.registerLazySingleton<PlacesLocalDataSource>(
    () => PlacesLocalDataSource(),
  );
  
  getIt.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSource(apiService: getIt<ApiService>()),
  );

  // --- Repositories ---
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(
      remoteDataSource: getIt<PlacesRemoteDataSource>(),  // محدث ⭐
      localDataSource: getIt<PlacesLocalDataSource>(),    // محدث ⭐
    ),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<SupabaseService>()),
  );

  // --- Cubits ---
  getIt.registerFactory(
    () => PlacesCubit(repository: getIt<PlacesRepository>()),
  );
  getIt.registerFactory(() => UserCubit(getIt<UserRepository>()));
}
```

---

### 3️⃣ إضافة Dependencies المطلوبة

تأكد من وجود هذه الحزم في `pubspec.yaml`:

```yaml
dependencies:
  # الحزم الموجودة مسبقاً...
  
  # إضافة connectivity_plus إذا لم تكن موجودة ⭐
  connectivity_plus: ^5.0.1
```

ثم قم بتشغيل:

```bash
flutter pub get
```

---

### 4️⃣ تحديث home_view.dart أو home_view_body.dart

استبدل الكود القديم بالكود الجديد الذي يدعم جميع الحالات:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/places_cubit.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    // تحميل الأماكن عند فتح الصفحة
    context.read<PlacesCubit>().loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlacesCubit, PlacesState>(
      listener: (context, state) {
        // عرض رسائل للمستخدم
        if (state is PlacesLoaded && state.isFromCache && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.orange,
            ),
          );
        }
        
        if (state is PlacesOfflineSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.warningMessage),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'إعادة المحاولة',
                onPressed: () => context.read<PlacesCubit>().reload(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PlacesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is PlacesLoaded) {
          // استخدم الويدجتات الموجودة لديك لعرض البيانات
          return RefreshIndicator(
            onRefresh: () => context.read<PlacesCubit>().reload(),
            child: CustomScrollView(
              slivers: [
                // Profile Section
                // BuildProfileSection(),
                
                // Search Bar
                // BuildSearchBar(),
                
                // Categories
                SliverToBoxAdapter(
                  child: BuildCategoryList(
                    categories: state.availableCategories,
                    categorized: state.categorized,
                  ),
                ),
                
                // Top Recommendations
                SliverToBoxAdapter(
                  child: BuildRecommendationList(
                    places: state.topRecommendations,
                  ),
                ),
                
                // Recently Viewed (إذا كان موجود)
                // BuildRecentlyViewed(),
              ],
            ),
          );
        }
        
        if (state is PlacesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state.errorType == PlacesErrorType.noInternet
                      ? Icons.wifi_off
                      : Icons.error_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  state.failure.errMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<PlacesCubit>().reload(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox();
      },
    );
  }
}
```

---

### 5️⃣ اختبار التطبيق

#### اختبار 1: مع إنترنت (أول مرة)
```
1. شغّل التطبيق
2. يجب أن يظهر Loading
3. يجب أن يجلب البيانات من API
4. يجب أن يعرض الأماكن
```

#### اختبار 2: بدون إنترنت (بعد وجود كاش)
```
1. أوقف الإنترنت
2. أغلق التطبيق وافتحه مرة أخرى
3. يجب أن يعرض البيانات من الكاش
4. يجب أن يظهر رسالة: "أنت غير متصل بالإنترنت"
```

#### اختبار 3: التحرك مسافة قصيرة (< 700م)
```
1. شغّل التطبيق في موقع
2. تحرك مسافة قصيرة (مثلاً 500 متر)
3. أغلق التطبيق وافتحه
4. يجب أن يستخدم الكاش فقط (بدون API call)
```

#### اختبار 4: التحرك مسافة طويلة (>= 700م)
```
1. شغّل التطبيق في موقع
2. تحرك مسافة طويلة (مثلاً 2 كم)
3. أغلق التطبيق وافتحه
4. يجب أن يعرض الكاش أولاً
5. ثم يحدث البيانات من API
```

---

## 🐛 استكشاف الأخطاء الشائعة

### خطأ: "type 'X' is not a subtype of type 'Y'"

**الحل:**
```bash
# احذف الملفات المولدة
flutter clean

# أعد توليدها
flutter pub run build_runner build --delete-conflicting-outputs

# أعد تشغيل التطبيق
flutter run
```

### خطأ: "Unhandled Exception: HiveError: Cannot read, unknown typeId"

**الحل:**
تأكد من تسجيل جميع Adapters في main.dart قبل استخدام Hive

### خطأ: "Location services are disabled"

**الحل:**
1. فعّل GPS على الجهاز
2. تأكد من إضافة الأذونات في:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

---

## 📝 ملاحظات مهمة

### 1. TypeId في Hive

تأكد من أن كل نموذج له `typeId` فريد:

```dart
@HiveType(typeId: 0)  // CachedPlacesModel
@HiveType(typeId: 1)  // PlaceModel
@HiveType(typeId: 2)  // OpeningHours
@HiveType(typeId: 3)  // ReviewModel
@HiveType(typeId: 10) // CachedLocationModel
@HiveType(typeId: 11) // CachedTopRecommendationsModel
@HiveType(typeId: 12) // CachedPlaceDetailsModel
@HiveType(typeId: 13) // CachedCategoriesModel
```

### 2. Console Logging

جميع الملفات تحتوي على `print` statements مفصلة لتتبع تدفق البيانات.
يمكنك إزالتها في الإصدار النهائي أو استخدام logger package.

### 3. API Key

تأكد من أن Google Places API Key صحيح في `api_constants.dart`

---

## ✅ Checklist النهائي

- [ ] تحديث main.dart بتسجيل Adapters الجديدة
- [ ] تحديث setup_service_locator.dart
- [ ] إضافة connectivity_plus dependency
- [ ] تشغيل flutter pub get
- [ ] تشغيل build_runner
- [ ] تحديث home_view_body.dart
- [ ] اختبار مع إنترنت
- [ ] اختبار بدون إنترنت
- [ ] اختبار distance logic
- [ ] مراجعة Console logs
- [ ] إزالة print statements (اختياري)

---

## 🎉 انتهى!

الآن لديك تطبيق كامل مع:
- ✅ Offline-First Architecture
- ✅ Distance-based caching
- ✅ Comprehensive error handling
- ✅ Clean Architecture
- ✅ SOLID Principles
- ✅ Detailed comments (Arabic + English)

للمزيد من التفاصيل، راجع: `OFFLINE_FIRST_IMPLEMENTATION.md`
