import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/places_cubit.dart';

class PlacesExampleUsage extends StatefulWidget {
  const PlacesExampleUsage({super.key});

  @override
  State<PlacesExampleUsage> createState() => _PlacesExampleUsageState();
}

class _PlacesExampleUsageState extends State<PlacesExampleUsage> {
  @override
  void initState() {
    super.initState();

    // 🚀 تحميل الأماكن عند فتح الصفحة
    // Load places when page opens
    //
    // هذا هو المكان الذي يبدأ فيه كل شيء
    // This is where everything starts
    context.read<PlacesCubit>().loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأماكن القريبة'),
        actions: [
          // زر إعادة التحميل
          // Reload button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PlacesCubit>().reload();
            },
          ),
        ],
      ),

      // 👂 الاستماع لحالات Cubit
      // Listen to Cubit states
      //
      // BlocBuilder يُعيد بناء الـ UI عند تغيير الحالة
      // BlocBuilder rebuilds UI when state changes
      body: BlocConsumer<PlacesCubit, PlacesState>(
        // 👂 Listener: للتعامل مع الأحداث الجانبية (رسائل، navigation، إلخ)
        // Listener: For handling side effects (messages, navigation, etc.)
        listener: (context, state) {
          // ✅ عند نجاح تحميل البيانات
          // On successful data loading
          if (state is PlacesLoaded) {
            // إذا كانت البيانات من الكاش، نعرض رسالة
            // If data is from cache, show message
            if (state.isFromCache && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
          // 📶 عند تحميل البيانات من الكاش (Offline)
          // On loading data from cache (Offline)
          else if (state is PlacesOfflineSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.warningMessage),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'إعادة المحاولة',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<PlacesCubit>().reload();
                  },
                ),
              ),
            );
          }
          // ❌ عند حدوث خطأ
          // On error
          else if (state is PlacesError) {
            // تحديد الرسالة والإجراء حسب نوع الخطأ
            // Determine message and action based on error type
            String message = state.failure.errMessage;
            const String actionLabel = 'إعادة المحاولة';
            action() => context.read<PlacesCubit>().reload();

            if (state.errorType == PlacesErrorType.noInternet) {
              message = 'لا يوجد اتصال بالإنترنت\nالرجاء التحقق من الاتصال';
            } else if (state.errorType == PlacesErrorType.noData) {
              message = 'لا توجد بيانات متاحة';
            } else if (state.errorType == PlacesErrorType.locationError) {
              message = 'خطأ في الحصول على الموقع\nالرجاء تفعيل خدمة الموقع';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: actionLabel,
                  textColor: Colors.white,
                  onPressed: action,
                ),
              ),
            );
          }
        },

        // 🏗️ Builder: لبناء الـ UI حسب الحالة
        // Builder: For building UI based on state
        builder: (context, state) {
          // ⚪ الحالة الأولية
          // Initial state
          if (state is PlacesInitial) {
            return const Center(child: Text('جاري التحضير...'));
          }
          // 🔄 حالة التحميل
          // Loading state
          else if (state is PlacesLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري تحميل الأماكن القريبة...'),
                ],
              ),
            );
          }
          // ✅ حالة النجاح
          // Success state
          else if (state is PlacesLoaded) {
            return _buildSuccessUI(state);
          }
          // 📶 حالة النجاح من الكاش (Offline)
          // Offline success state
          else if (state is PlacesOfflineSuccess) {
            return _buildOfflineSuccessUI(state);
          }
          // ❌ حالة الخطأ
          // Error state
          else if (state is PlacesError) {
            return _buildErrorUI(state);
          }

          // حالة غير معروفة
          // Unknown state
          return const Center(child: Text('حالة غير معروفة'));
        },
      ),
    );
  }

  /// 🏗️ بناء واجهة النجاح
  /// Build success UI
  Widget _buildSuccessUI(PlacesLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PlacesCubit>().reload();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🏷️ عرض عدد الأماكن
          // Display places count
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('عدد الأماكن: ${state.places.length}'),
                  Text('عدد الفئات: ${state.availableCategories.length}'),
                  Text('عدد التوصيات: ${state.topRecommendations.length}'),
                  if (state.isFromCache)
                    const Text(
                      '📦 البيانات من الكاش المحلي',
                      style: TextStyle(color: Colors.orange),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🌟 الأماكن الأعلى تقييماً
          // Top rated places
          Text(
            'الأماكن الأعلى تقييماً',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...state.topRecommendations.map((place) {
            return Card(
              child: ListTile(
                title: Text(place.name),
                subtitle: Text(place.vicinity),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('${place.rating ?? 0.0}'),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // 📂 الفئات المتاحة
          // Available categories
          Text('الفئات المتاحة', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                state.availableCategories.entries.map((entry) {
                  final count = state.categorized[entry.key]?.length ?? 0;
                  return Chip(label: Text('${entry.value} ($count)'));
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// 🏗️ بناء واجهة النجاح من الكاش (Offline)
  /// Build offline success UI
  Widget _buildOfflineSuccessUI(PlacesOfflineSuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PlacesCubit>().reload();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ⚠️ رسالة تحذيرية
          // Warning message
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.warningMessage,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // عرض البيانات (مشابه لـ _buildSuccessUI)
          // Display data (similar to _buildSuccessUI)
          Text(
            'الأماكن الأعلى تقييماً',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...state.topRecommendations.map((place) {
            return Card(
              child: ListTile(
                title: Text(place.name),
                subtitle: Text(place.vicinity),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('${place.rating ?? 0.0}'),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 🏗️ بناء واجهة الخطأ
  /// Build error UI
  Widget _buildErrorUI(PlacesError state) {
    // تحديد الأيقونة والرسالة حسب نوع الخطأ
    // Determine icon and message based on error type
    IconData icon = Icons.error_outline;
    String title = 'حدث خطأ';
    String message = state.failure.errMessage;

    if (state.errorType == PlacesErrorType.noInternet) {
      icon = Icons.wifi_off;
      title = 'لا يوجد اتصال بالإنترنت';
      message = 'الرجاء التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';
    } else if (state.errorType == PlacesErrorType.noData) {
      icon = Icons.inbox_outlined;
      title = 'لا توجد بيانات';
      message = 'لا توجد أماكن متاحة في هذا الموقع';
    } else if (state.errorType == PlacesErrorType.locationError) {
      icon = Icons.location_off;
      title = 'خطأ في الموقع';
      message = 'الرجاء تفعيل خدمة الموقع والسماح للتطبيق بالوصول إليه';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PlacesCubit>().reload();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
