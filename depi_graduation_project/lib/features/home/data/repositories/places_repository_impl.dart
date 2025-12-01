import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whatsapp/core/helper/app_logger.dart';
import '../../../../core/errors/server_failure.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/network_checker.dart';
import '../../../../core/utils/helpers/distance_calculator.dart';
import '../data_sources/places_local_data_source.dart';
import '../data_sources/places_remote_data_source.dart';
import '../models/place_model.dart';
import 'places_repository.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;
  final PlacesLocalDataSource localDataSource;

  PlacesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Either<ServerFailure, List<PlaceModel>>> getNearbyPlaces() async* {
    print('Starting nearby places fetch process\n');

    try {
      print(' Step 1: Getting current location...');

      final Position currentPosition =
          await LocationService.instance.getCurrentLocation();

     AppLogger.info(
        'Current location: (${currentPosition.latitude}, ${currentPosition.longitude})\n',
      );
      AppLogger.info('Step 2: Checking cache existence...');

      final cachedPlaces = await localDataSource.getCachedNearbyPlaces();
      final cachedLocation = await localDataSource.getLastLocation();

      // ==================== Step 3: Determine Strategy ====================

      bool shouldUseCache = false;
      bool shouldCallAPI = true;
      double? distanceFromCache;

      if (cachedPlaces != null && cachedLocation != null) {
       AppLogger.info(' Cache found');

        // Calculate distance between current and cached location
        distanceFromCache = DistanceCalculator.calculateDistance(
          lat1: currentPosition.latitude,
          lon1: currentPosition.longitude,
          lat2: cachedLocation.latitude,
          lon2: cachedLocation.longitude,
        );
        AppLogger.info(
          'Distance from cache: ${DistanceCalculator.formatDistance(distanceFromCache)}',
        );

        // Check if distance is within threshold (700 meters)
        if (DistanceCalculator.isWithinThreshold(
          distance: distanceFromCache,
          thresholdMeters: DistanceConstants.cacheThresholdMeters,
        )) {
          AppLogger.info(
            'Distance less than ${DistanceConstants.cacheThresholdMeters} meters',
          );
          AppLogger.info(' Will use cache only without API call\n');

          shouldUseCache = true;
          shouldCallAPI = false;
        } else {
          AppLogger.info(
            'Distance greater than ${DistanceConstants.cacheThresholdMeters} meters',
          );
          AppLogger.info(' Will call API to update data\n');

          shouldUseCache = true; // Show cache first then update it
          shouldCallAPI = true; // We show cache first then update it
        }
      } else {
        AppLogger.info(' No cache found');
        AppLogger.info('Will call API to fetch data\n');

        shouldUseCache = false;
        shouldCallAPI = true;
      }

      // ==================== Step 4: Show Cache if Exists ====================

      if (shouldUseCache && cachedPlaces != null) {
        print('Emitting cached data...');

        yield Right(cachedPlaces.places);

        print(' Emitted ${cachedPlaces.places.length} places from cache\n');
      }

      // ==================== Step 5: Call API if Needed ====================

      if (shouldCallAPI) {
        AppLogger.info(' Attempting API call...');

        // Check internet connection
        final bool isConnected = await NetworkChecker.instance.isConnected();

        if (!isConnected) {
          AppLogger.info('No internet connection');

          if (shouldUseCache) {
            // We have cache, no need to emit error
            AppLogger.info('Will use existing cache');
            AppLogger.info(' Warning: Data might be outdated\n');
          } else {
            // No cache and no internet
            AppLogger.info(' No data available\n');

            yield Left(
              ServerFailure(
                errMessage: 'No internet connection and no cached data',
              ),
            );
          }
          return;
        }

        // Internet connection exists, try fetching data
        try {
          AppLogger.info(' Fetching data from API...');

          final places = await remoteDataSource.getNearbyPlaces(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          );

          AppLogger.info(' Fetched ${places.length} places from API');

          // Save data to cache
          AppLogger.info(' Saving data to cache...');

          await localDataSource.cacheNearbyPlaces(
            places: places,
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          );

          await localDataSource.saveLastLocation(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          );

          AppLogger.info('✅ Data saved to cache');

          // Emit new data
          AppLogger.info('📤 Emitting API data...');

          yield Right(places);

          AppLogger.info('✅ Emitted ${places.length} places from API\n');
        } catch (e) {
          AppLogger.error('❌ API call failed: $e');

          if (shouldUseCache) {
            // We have cache, no need to emit error
            print('Will rely on existing cache');
            print(' Warning: Failed to update data\n');
          } else {
            // No cache, emit error
            AppLogger.info(' No data available\n');

            yield Left(
              ServerFailure(
                errMessage: 'Failed to fetch data: ${e.toString()}',
              ),
            );
          }
        }
      }

      print('✅ Nearby places fetch process completed\n');
    } catch (e) {
      print(' General error: $e\n');

      yield Left(
        ServerFailure(
          errMessage:
              'General error: ${e.toString()}\nError occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<Either<ServerFailure, Map<String, dynamic>>> getPlaceDetails(
    String placeId,
  ) async* {
    print(' Starting place details fetch process');
    print(' Place ID: $placeId\n');

    try {
      // ==================== Step 1: Check Cache ====================
      print('Step 1: Checking cache...');

      final cachedDetails = await localDataSource.getCachedPlaceDetails(
        placeId,
      );

      final bool hasCachedData = cachedDetails != null;

      if (hasCachedData) {
        print('Found details in cache');
        print(' Emitting cached data...');

        yield Right(cachedDetails.details);

        print(' Emitted cached data\n');
      } else {
        print(' No cache for this place\n');
      }

      // ==================== Step 2: Try Fetching Fresh Data ====================
      print('Step 2: Attempting to fetch fresh data from API...');

      // Check internet connection
      final bool isConnected = await NetworkChecker.instance.isConnected();

      if (!isConnected) {
        print('No internet connection');

        if (hasCachedData) {
          print(' Will use existing cache\n');
          // We have cache, don't emit error
        } else {
          print('No data available\n');

          yield Left(
            ServerFailure(
              errMessage: 'No internet connection and no cached data',
            ),
          );
        }
        return;
      }

      // Connection exists, try fetching data
      try {
        print(' Fetching data from API...');

        final details = await remoteDataSource.getPlaceDetails(
          placeId: placeId,
        );

        print('✅ Fetched details from API');

        // Save to cache
        print(' Saving data to cache...');

        await localDataSource.cachePlaceDetails(
          placeId: placeId,
          details: details,
        );

        print(' Data saved to cache');

        // Emit new data
        print(' Emitting API data...');

        yield Right(details);

        print(' Emitted API data\n');
      } catch (e) {
        print(' API call failed: $e');

        if (hasCachedData) {
          print(' Will rely on existing cache\n');
          // We have cache, don't emit error
        } else {
          print(' No data available\n');

          yield Left(
            ServerFailure(errMessage: 'Failed to fetch data: ${e.toString()}'),
          );
        }
      }

      print(' Place details fetch process completed\n');
    } catch (e) {
      print(' General error: $e\n');

      yield Left(
        ServerFailure(
          errMessage:
              'حدث خطأ: ${e.toString()}\nError occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<Either<ServerFailure, Map<String, dynamic>>> getRecommendedPlaces(
    String placeId,
  ) async* {
    print(' Starting recommended places fetch process');
    print(' Based on place: $placeId\n');

    try {
      // Note: Can add cache for recommended places later
      // Currently will rely on API only

      print('🌐 Checking internet connection...');

      final bool isConnected = await NetworkChecker.instance.isConnected();

      if (!isConnected) {
        print(' No internet connection\n');

        yield Left(ServerFailure(errMessage: 'No internet connection'));
        return;
      }

      print(' Fetching data from API...');

      final recommendedData = await remoteDataSource.getRecommendedPlaces(
        placeId: placeId,
      );

      print('✅ Fetched recommended places from API');

      print(' Emitting data...');

      yield Right(recommendedData);

      print(' Data emitted\n');

      print(' Recommended places fetch process completed\n');
    } catch (e) {
      print('❌ Error: $e\n');

      yield Left(
        ServerFailure(errMessage: 'Failed to fetch data: ${e.toString()}'),
      );
    }
  }
}
