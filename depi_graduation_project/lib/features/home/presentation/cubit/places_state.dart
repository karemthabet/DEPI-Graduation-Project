part of 'places_cubit.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;
  final Map<String, dynamic>? placeDetails;

  PlacesLoaded({
    required this.places,
    required this.categorized,
    this.placeDetails,
  });

  PlacesLoaded copyWith({
    List<PlaceModel>? places,
    Map<String, List<PlaceModel>>? categorized,
    Map<String, dynamic>? placeDetails,
  }) {
    return PlacesLoaded(
      places: places ?? this.places,
      categorized: categorized ?? this.categorized,
      placeDetails: placeDetails ?? this.placeDetails,
    );
  }
}

class PlaceDetailsLoading extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;

  PlaceDetailsLoading({required this.places, required this.categorized});
}

class PlacesError extends PlacesState {
  final ServerFailure failure;
  PlacesError({required this.failure});
}
