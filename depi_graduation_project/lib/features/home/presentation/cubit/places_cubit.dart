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
    print('Cubit: Starting places loading\n');

    // Emit loading state
    emit(PlacesLoading());
    print(' Cubit: Emitted PlacesLoading\n');

    // Variable to track number of emissions from Stream
    int emissionCount = 0;

    // Listen to Stream
    print(' Cubit: Listening to Stream from Repository...\n');

    repository.getNearbyPlaces().listen(
      (result) {
        emissionCount++;
        print(' Cubit: Received emission #$emissionCount from Stream\n');

        // Process result
        result.fold(
          (failure) {
            print(' Cubit: Received error');
            print('  Error: ${failure.errMessage}\n');

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

            print(' Cubit: Emitted PlacesError');
          },

          //    On success
          (places) {
            print('Cubit: Received ${places.length} places\n');

            // Process data
            print(' Cubit: Processing data...\n');

            // Categorize places by type
            final categorized = _groupByCategory(places);
            print(
              ' Categorized places into ${categorized.length} categories\n',
            );

            // Get available categories
            final availableCategories = getAvailableCategories(categorized);
            print('Found ${availableCategories.length} available categories\n');

            // Get top rated places
            final topRecommendations = getTopRecommendations(places, limit: 10);

            print(' Selected ${topRecommendations.length} top rated places\n');

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

            print(' Cubit: Emitted PlacesLoaded');
          },
        );
      },
      onError: (error) {
        // In case of error in Stream itself
        print('❌ Cubit: خطأ في Stream: $error');
        print('❌ Cubit: Stream error: $error\n');

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
        // عند انتهاء Stream
        // When Stream completes
        print('✅ Cubit: انتهى Stream');
        print('✅ Cubit: Stream completed');
        print('📊 عدد الإرسالات الكلي - Total emissions: $emissionCount\n');
      },
    );
  }

  Map<String, List<PlaceModel>> _groupByCategory(List<PlaceModel> places) {
    print('Categorizing ${places.length} places by type...');

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
    print(' Extracting available categories...');

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

    print('✅ Found ${result.length} available categories');

    return result;
  }

  List<PlaceModel> getTopRecommendations(
    List<PlaceModel> places, {
    int limit = 10,
  }) {
    print('🌟 Selecting top $limit places from ${places.length} places...');

    // Filter places that have rating
    final ratedPlaces = places.where((p) => p.rating != null).toList();

    print('Rated places count: ${ratedPlaces.length}');

    // Sort descending by rating
    ratedPlaces.sort((a, b) => b.rating!.compareTo(a.rating!));

    // Take first [limit] places
    final topPlaces = ratedPlaces.take(limit).toList();

    print(' Selected ${topPlaces.length} top rated places');

    if (topPlaces.isNotEmpty) {
      print(' Highest rating: ${topPlaces.first.rating}');
      print('Lowest in list: ${topPlaces.last.rating}');
    }
    print('');

    return topPlaces;
  }

  ///   User taps retry button
  Future<void> reload() async {
    print('🔄 Reloading data...\n');

    await loadPlaces();
  }
}
