part of 'places_cubit.dart';

/// Used when Cubit is first created
abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;

  final Map<String, List<PlaceModel>> categorized;

  ///Available categories
  /// {'restaurant': 'مطاعم', 'museum': 'متاحف'}

  final Map<String, String> availableCategories;

  ///  Top rated places
  final List<PlaceModel> topRecommendations;

  ///  Data source
  /// true =(Cache)
  /// false = API
  final bool isFromCache;

  /// Optional message for user
  /// Example: "Data might be outdated" when using cache
  final String? message;

  PlacesLoaded({
    required this.places,
    required this.categorized,
    required this.availableCategories,
    required this.topRecommendations,
    this.isFromCache = false,
    this.message,
  });

  /// Copy state with modified values
  PlacesLoaded copyWith({
    List<PlaceModel>? places,
    Map<String, List<PlaceModel>>? categorized,
    Map<String, String>? availableCategories,
    List<PlaceModel>? topRecommendations,
    bool? isFromCache,
    String? message,
  }) {
    return PlacesLoaded(
      places: places ?? this.places,
      categorized: categorized ?? this.categorized,
      availableCategories: availableCategories ?? this.availableCategories,
      topRecommendations: topRecommendations ?? this.topRecommendations,
      isFromCache: isFromCache ?? this.isFromCache,
      message: message ?? this.message,
    );
  }
}

class PlacesOfflineSuccess extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;
  final Map<String, String> availableCategories;
  final List<PlaceModel> topRecommendations;

  /// Warning message for user
  /// Example: "You're offline. Displayed data might be outdated"
  final String warningMessage;

  PlacesOfflineSuccess({
    required this.places,
    required this.categorized,
    required this.availableCategories,
    required this.topRecommendations,
    this.warningMessage = 'You\'re offline. Displayed data might be outdated',
  });
}

class PlacesError extends PlacesState {
  final ServerFailure failure;

  /// Helps determine how to display error to user
  final PlacesErrorType errorType;

  PlacesError({
    required this.failure,
    this.errorType = PlacesErrorType.general,
  });
}

/// Places error types
enum PlacesErrorType { general, noInternet, noData, locationError, serverError }
