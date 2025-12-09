import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/core/services/google_maps_place_service.dart';
import 'package:whatsapp/models/search_cache_model.dart';
import 'package:whatsapp/features/home/data/models/cached_place_details_model.dart';

class SearchRepository {
  final GoogleMapsPlaceService service;
  final Box<SearchCacheModel> predictionCacheBox;
  final Box<CachedPlaceDetailsModel> placeDetailsCacheBox;

  SearchRepository(
    this.service,
    this.predictionCacheBox,
    this.placeDetailsCacheBox,
  );

  String sessionToken = const Uuid().v4();

  Future<List<dynamic>> search(String query) async {
    if (query.isEmpty) return [];

    // --------- 1) Check Cache First ---------
    if (predictionCacheBox.containsKey(query)) {
      final cached = predictionCacheBox.get(query)!;

      if (!cached.isExpired) {
        return cached.predictionsJson;
      }
    }

    // --------- 2) Fetch Remote ---------
    final predictions = await service.fetchPredictions(
      input: query,
      sessionToken: sessionToken,
    );

    // --------- 3) Save into Cache ---------
    predictionCacheBox.put(
      query,
      SearchCacheModel(
        query: query,
        predictionsJson: predictions,
        cachedAt: DateTime.now(),
      ),
    );

    return predictions;
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String id) async {
    // 1) Check Cache
    if (placeDetailsCacheBox.containsKey(id)) {
      return placeDetailsCacheBox.get(id)!.details;
    }

    // 2) Fetch Remote
    final details = await service.fetchPlaceDetails(id);

    // 3) Save into Cache
    if (details != null) {
      placeDetailsCacheBox.put(
        id,
        CachedPlaceDetailsModel(
          placeId: id,
          details: details,
          timestamp: DateTime.now(),
        ),
      );
    }

    return details;
  }
}
