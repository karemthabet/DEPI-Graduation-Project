part of 'places_cubit.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final Map<String, List<PlaceModel>> categorized;
  PlacesLoaded(this.places, this.categorized);
}

class PlacesError extends PlacesState {
  final String message;
  PlacesError(this.message);
}
