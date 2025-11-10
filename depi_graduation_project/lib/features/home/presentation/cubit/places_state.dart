part of 'places_cubit.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;
  final Map<String, String> availableCategories;

  PlacesLoaded({
    required this.places,
    required this.categorized,
    required this.availableCategories,
  });

  PlacesLoaded copyWith({
    List<PlaceModel>? places,
    Map<String, List<PlaceModel>>? categorized,
    Map<String, String>? availableCategories,
  }) {
    return PlacesLoaded(
      places: places ?? this.places,
      categorized: categorized ?? this.categorized,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}

class PlacesError extends PlacesState {
  final ServerFailure failure;
  PlacesError({required this.failure});
}
