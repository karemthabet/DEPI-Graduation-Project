import 'package:hive/hive.dart';
import '../models/cached_categories_model.dart';
import '../models/cached_location_model.dart';
import '../models/cached_place_details_model.dart';
import '../models/cached_places_model.dart';
import '../models/cached_top_recommendations_model.dart';
import '../models/place_model.dart';

class PlacesLocalDataSource {
  //  Hive box names
  static const String _nearbyPlacesBoxName = 'nearby_places_cache';
  static const String _topRecommendationsBoxName = 'top_recommendations_cache';
  static const String _placeDetailsBoxName = 'place_details_cache';
  static const String _categoriesBoxName = 'categories_cache';
  static const String _lastLocationBoxName = 'last_location_cache';

  Future<void> cacheNearbyPlaces({
    required List<PlaceModel> places,
    required double latitude,
    required double longitude,
  }) async {
    final box = await Hive.openBox<CachedPlacesModel>(_nearbyPlacesBoxName);

    // Delete old cache before saving new one
    await box.clear();

    // Save new data
    final cachedData = CachedPlacesModel(
      lat: latitude,
      lng: longitude,
      places: places,
    );

    await box.add(cachedData);
    print(' Cached ${places.length} places');
  }

  Future<CachedPlacesModel?> getCachedNearbyPlaces() async {
    final box = await Hive.openBox<CachedPlacesModel>(_nearbyPlacesBoxName);

    if (box.isEmpty) {
      print(' No cache for nearby places');
      return null;
    }

    final cached = box.values.first;
    print(' Found ${cached.places.length} places in cache');
    return cached;
  }

  /// Delete nearby places cache
  Future<void> clearNearbyPlacesCache() async {
    final box = await Hive.openBox<CachedPlacesModel>(_nearbyPlacesBoxName);
    await box.clear();
    print('🗑️ Nearby places cache cleared');
  }

  // ==================== Top Recommendations ====================

  /// Save top recommendations to cache
  Future<void> cacheTopRecommendations({
    required List<PlaceModel> topPlaces,
    required double latitude,
    required double longitude,
  }) async {
    final box = await Hive.openBox<CachedTopRecommendationsModel>(
      _topRecommendationsBoxName,
    );

    await box.clear();

    final cachedData = CachedTopRecommendationsModel(
      topPlaces: topPlaces,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );

    await box.add(cachedData);
    print(' Cached ${topPlaces.length} recommendations');
  }

  /// Get top recommendations from cache
  Future<CachedTopRecommendationsModel?> getCachedTopRecommendations() async {
    final box = await Hive.openBox<CachedTopRecommendationsModel>(
      _topRecommendationsBoxName,
    );

    if (box.isEmpty) {
      print(' No cache for recommendations');
      return null;
    }

    final cached = box.values.first;
    print('Found ${cached.topPlaces.length} recommendations in cache');
    return cached;
  }

  /// Delete recommendations cache
  Future<void> clearTopRecommendationsCache() async {
    final box = await Hive.openBox<CachedTopRecommendationsModel>(
      _topRecommendationsBoxName,
    );
    await box.clear();
    print('Recommendations cache cleared');
  }

  // ==================== Place Details ====================

  /// Save place details to cache
  Future<void> cachePlaceDetails({
    required String placeId,
    required Map<String, dynamic> details,
  }) async {
    final box = await Hive.openBox<CachedPlaceDetailsModel>(
      _placeDetailsBoxName,
    );

    // Search for existing place details
    final existingIndex = box.values.toList().indexWhere(
      (item) => item.placeId == placeId,
    );

    final cachedData = CachedPlaceDetailsModel(
      placeId: placeId,
      details: details,
      timestamp: DateTime.now(),
    );

    if (existingIndex != -1) {
      // Update existing data
      await box.putAt(existingIndex, cachedData);
      print(' Updated place details: $placeId');
    } else {
      // Add new data
      await box.add(cachedData);
      print('Cached place details: $placeId');
    }
  }

  /// Get place details from cache
  Future<CachedPlaceDetailsModel?> getCachedPlaceDetails(String placeId) async {
    final box = await Hive.openBox<CachedPlaceDetailsModel>(
      _placeDetailsBoxName,
    );

    if (box.isEmpty) {
      print('No cache for place details');
      return null;
    }

    // Search for place by placeId
    try {
      final cached = box.values.firstWhere((item) => item.placeId == placeId);
      print(' Found place details: $placeId');
      return cached;
    } catch (e) {
      print(' Place details not found: $placeId');
      return null;
    }
  }

  /// Delete specific place details from cache
  Future<void> deletePlaceDetails(String placeId) async {
    final box = await Hive.openBox<CachedPlaceDetailsModel>(
      _placeDetailsBoxName,
    );

    final index = box.values.toList().indexWhere(
      (item) => item.placeId == placeId,
    );

    if (index != -1) {
      await box.deleteAt(index);
      print(' Deleted place details: $placeId');
    }
  }

  /// Delete all place details from cache
  Future<void> clearAllPlaceDetailsCache() async {
    final box = await Hive.openBox<CachedPlaceDetailsModel>(
      _placeDetailsBoxName,
    );
    await box.clear();
    print('All place details cache cleared');
  }

  // ==================== Categories ====================

  /// Save available categories to cache
  Future<void> cacheCategories({
    required Map<String, String> categories,
    required double latitude,
    required double longitude,
  }) async {
    final box = await Hive.openBox<CachedCategoriesModel>(_categoriesBoxName);

    await box.clear();

    final cachedData = CachedCategoriesModel(
      categories: categories,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );

    await box.add(cachedData);
    print(' Cached ${categories.length} categories');
  }

  /// Get available categories from cache
  Future<CachedCategoriesModel?> getCachedCategories() async {
    final box = await Hive.openBox<CachedCategoriesModel>(_categoriesBoxName);

    if (box.isEmpty) {
      print(' No cache for categories');
      return null;
    }

    final cached = box.values.first;
    print(' Found ${cached.categories.length} categories in cache');
    return cached;
  }

  /// Delete categories cache
  Future<void> clearCategoriesCache() async {
    final box = await Hive.openBox<CachedCategoriesModel>(_categoriesBoxName);
    await box.clear();
    print('Categories cache cleared');
  }

  // ==================== Last Location ====================

  /// Save user's last location
  Future<void> saveLastLocation({
    required double latitude,
    required double longitude,
  }) async {
    final box = await Hive.openBox<CachedLocationModel>(_lastLocationBoxName);

    await box.clear();

    final location = CachedLocationModel(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    );

    await box.add(location);
    print('Saved last location: ($latitude, $longitude)');
  }

  Future<CachedLocationModel?> getLastLocation() async {
    final box = await Hive.openBox<CachedLocationModel>(_lastLocationBoxName);

    if (box.isEmpty) {
      print('No saved location');
      return null;
    }

    final location = box.values.first;
    print(
      ' Found last location: (${location.latitude}, ${location.longitude})',
    );
    return location;
  }

  /// Delete last location
  Future<void> clearLastLocation() async {
    final box = await Hive.openBox<CachedLocationModel>(_lastLocationBoxName);
    await box.clear();
    print('Last location cleared');
  }

  // ==================== Clear All Cache ====================

  /// Clear all cached data
  Future<void> clearAllCache() async {
    await clearNearbyPlacesCache();
    await clearTopRecommendationsCache();
    await clearAllPlaceDetailsCache();
    await clearCategoriesCache();
    await clearLastLocation();
    print(' All cache cleared');
  }
}
