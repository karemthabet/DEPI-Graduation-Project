import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/errors/server_failure.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/places_repository.dart';
import '../../../../core/utils/constants/app_constants.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlacesRepository repository;

  PlacesCubit({required this.repository}) : super(PlacesInitial());

  Future<void> loadPlaces() async {
    // Emit loading state
    emit(PlacesLoading());

    // Variable to track number of emissions from Stream
    int emissionCount = 0;

    repository.getNearbyPlaces().listen(
      (result) {
        emissionCount++;

        // Process result
        result.fold(
          (failure) {
            // Determine error type
            PlacesErrorType errorType = PlacesErrorType.general;

            if (failure.errMessage.contains('No internet') ||
                failure.errMessage.contains('لا يوجد اتصال')) {
              errorType = PlacesErrorType.noInternet;
            } else if (failure.errMessage.contains('No data') ||
                failure.errMessage.contains('لا توجد بيانات')) {
              errorType = PlacesErrorType.noData;
            } else if (failure.errMessage.contains('Location') ||
                failure.errMessage.contains('الموقع')) {
              errorType = PlacesErrorType.locationError;
            }

            // Emit error state
            emit(PlacesError(failure: failure, errorType: errorType));
          },

          //    On success
          (places) {
            // Process data

            // Categorize places by type
            final categorized = _groupByCategory(places);

            // Get available categories
            final availableCategories = getAvailableCategories(categorized);

            // Get top rated places
            final topRecommendations = getTopRecommendations(places, limit: 10);

            // Determine if data is from cache
            final bool isFromCache = emissionCount == 1;
            // First emission is usually from cache

            // Emit success state
            emit(
              PlacesLoaded(
                places: places,
                categorized: categorized,
                availableCategories: availableCategories,
                topRecommendations: topRecommendations,
                isFromCache: isFromCache,
                message: isFromCache ? 'Data from local cache' : null,
              ),
            );
          },
        );
      },
      onError: (error) {
        // In case of error in Stream itself

        emit(
          PlacesError(
            failure: ServerFailure(
              errMessage: 'حدث خطأ غير متوقع\nUnexpected error occurred',
            ),
            errorType: PlacesErrorType.general,
          ),
        );
      },
      onDone: () {
        // When Stream completes
      },
    );
  }

  Map<String, List<PlaceModel>> _groupByCategory(List<PlaceModel> places) {
    final Map<String, List<PlaceModel>> map = {};

    for (var place in places) {
      final category = place.category.toLowerCase();

      // Check if category exists in known categories
      if (AppConstants.categories.containsKey(category)) {
        map.putIfAbsent(category, () => []).add(place);
      } else {
        // If category is unknown, put it in "others"
        map.putIfAbsent('others', () => []).add(place);
      }
    }

    // Print categorization summary
    map.forEach((category, places) {
      print('   - $category: ${places.length} أماكن / places');
    });
    print('');

    return map;
  }

  ///   Categories are sorted with "others" at the end
  Map<String, String> getAvailableCategories(
    Map<String, List<PlaceModel>> categorized,
  ) {
    // Filter categories that have places
    final availableCategories =
        AppConstants.categories.entries
            .where(
              (entry) =>
                  categorized.containsKey(entry.key) &&
                  categorized[entry.key]!.isNotEmpty,
            )
            .toList();

    // Sort categories with "others" at the end
    availableCategories.sort((a, b) {
      if (a.key == 'others') return 1;
      if (b.key == 'others') return -1;
      return 0;
    });

    final result = {for (var e in availableCategories) e.key: e.value};

    return result;
  }

  List<PlaceModel> getTopRecommendations(
    List<PlaceModel> places, {
    int limit = 10,
  }) {
    // Filter places that have rating
    final ratedPlaces = places.where((p) => p.rating != null).toList();

    // Sort descending by rating
    ratedPlaces.sort((a, b) => b.rating!.compareTo(a.rating!));

    // Take first [limit] places
    final topPlaces = ratedPlaces.take(limit).toList();

    if (topPlaces.isNotEmpty) {}

    return topPlaces;
  }

  ///   User taps retry button
  Future<void> reload() async {
    await loadPlaces();
  }
}
