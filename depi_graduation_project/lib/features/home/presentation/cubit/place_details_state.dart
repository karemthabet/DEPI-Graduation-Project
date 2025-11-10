part of 'place_details_cubit.dart';

abstract class PlaceDetailsState {}

class PlaceDetailsInitial extends PlaceDetailsState {}

class PlaceDetailsLoading extends PlaceDetailsState {}

class PlaceDetailsLoaded extends PlaceDetailsState {
  final Map<String, dynamic> details;

  PlaceDetailsLoaded({required this.details});
}

class PlaceDetailsError extends PlaceDetailsState {
  final ServerFailure failure;

  PlaceDetailsError({required this.failure});
}
