part of 'places_cubit.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;

  PlacesLoaded({required this.places, required this.categorized});
}

class PlaceDetailsLoaded extends PlacesState {
  final Map<String, dynamic> details;

  PlaceDetailsLoaded({required this.details});
}

class PlacesError extends PlacesState {
  final ServerFailure failure;

  PlacesError({required this.failure});
}
