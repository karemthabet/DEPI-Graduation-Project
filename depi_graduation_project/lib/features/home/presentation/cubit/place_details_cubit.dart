import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/places_repository.dart';
import '../../../../core/errors/server_failure.dart';

part 'place_details_state.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  final PlacesRepository repository;

  PlaceDetailsCubit(this.repository) : super(PlaceDetailsInitial());

  Future<void> loadPlaceDetails(String placeId) async {
    emit(PlaceDetailsLoading());

    final result = await repository.getPlaceDetails(placeId);
    result.fold(
      (failure) => emit(PlaceDetailsError(failure: failure)),
      (details) => emit(PlaceDetailsLoaded(details: details)),
    );
  }

  void reset() {
    emit(PlaceDetailsInitial());
  }
}
