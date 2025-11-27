part of 'place_details_cubit.dart';

/// 🎯 حالات Place Details Cubit
/// Place Details Cubit States

abstract class PlaceDetailsState {}

/// ⚪ الحالة الأولية - Initial State
class PlaceDetailsInitial extends PlaceDetailsState {}

/// 🔄 حالة التحميل - Loading State
class PlaceDetailsLoading extends PlaceDetailsState {}

/// ✅ حالة النجاح - Success State
///
/// تحتوي على تفاصيل المكان
/// Contains place details
class PlaceDetailsLoaded extends PlaceDetailsState {
  /// تفاصيل المكان - Place details
  final Map<String, dynamic> details;

  /// مصدر البيانات - Data source
  /// true = من الكاش (Cache)
  /// false = من API
  final bool isFromCache;

  /// رسالة اختيارية - Optional message
  final String? message;

  PlaceDetailsLoaded({
    required this.details,
    this.isFromCache = false,
    this.message,
  });
}

/// 📶 حالة النجاح من الكاش (Offline) - Offline Success State
class PlaceDetailsOfflineSuccess extends PlaceDetailsState {
  final Map<String, dynamic> details;

  /// رسالة تحذيرية - Warning message
  final String warningMessage;

  PlaceDetailsOfflineSuccess({
    required this.details,
    this.warningMessage =
        'أنت غير متصل بالإنترنت. البيانات المعروضة قد تكون قديمة\n'
            'You\'re offline. Displayed data might be outdated',
  });
}

/// ❌ حالة الخطأ - Error State
class PlaceDetailsError extends PlaceDetailsState {
  final ServerFailure failure;
  final PlaceDetailsErrorType errorType;

  PlaceDetailsError({
    required this.failure,
    this.errorType = PlaceDetailsErrorType.general,
  });
}

/// 📊 أنواع أخطاء Place Details
/// Place Details error types
enum PlaceDetailsErrorType {
  /// خطأ عام - General error
  general,

  /// لا يوجد اتصال بالإنترنت - No internet connection
  noInternet,

  /// المكان غير موجود - Place not found
  notFound,

  /// خطأ في الخادم - Server error
  serverError,
}
