import 'package:equatable/equatable.dart';
import '../../../../core/errors/server_failure.dart';
import '../../data/models/favourite_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavouriteModel> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final ServerFailure failure;

  const FavoritesError(this.failure);

  @override
  List<Object?> get props => [failure];
}
