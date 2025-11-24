part of 'places_cubit.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;
  final Map<String, String> availableCategories;
  final List<PlaceModel> topRecommendations;

  PlacesLoaded({
    required this.places,
    required this.categorized,
    required this.availableCategories,
    required this.topRecommendations,
  });

  PlacesLoaded copyWith({
    List<PlaceModel>? places,
    Map<String, List<PlaceModel>>? categorized,
    Map<String, String>? availableCategories,
    List<PlaceModel>? topRecommendations,
  }) {
    return PlacesLoaded(
      places: places ?? this.places,
      categorized: categorized ?? this.categorized,
      availableCategories: availableCategories ?? this.availableCategories,
      topRecommendations: topRecommendations ?? this.topRecommendations,
    );
  }
}

class PlacesError extends PlacesState {
  final ServerFailure failure;
  PlacesError({required this.failure});
}
