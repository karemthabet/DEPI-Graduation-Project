import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/places_repository.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlacesRepository repo;

  PlacesCubit(this.repo) : super(PlacesInitial());

  Future<void> loadNearbyPlaces() async {
    emit(PlacesLoading());
    try {
      final places = await repo.getNearbyPlaces();
      final categorized = _groupByCategory(places);
      emit(PlacesLoaded(places, categorized));
    } catch (e) {
      emit(PlacesError(e.toString()));
    }
  }

  Map<String, List<PlaceModel>> _groupByCategory(List<PlaceModel> places) {
    final Map<String, List<PlaceModel>> map = {};
    for (var p in places) {
      map.putIfAbsent(p.category, () => []).add(p);
    }
    return map;
  }

  Future<Map<String, dynamic>> loadPlaceDetails(String id) async {
    return await repo.getPlaceDetails(id);
  }
}
