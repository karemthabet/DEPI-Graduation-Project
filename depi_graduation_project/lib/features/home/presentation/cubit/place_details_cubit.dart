import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/places_repository.dart';
import '../../../../core/errors/server_failure.dart';

part 'place_details_state.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  final PlacesRepository repository;

  PlaceDetailsCubit(this.repository) : super(PlaceDetailsInitial());

  Future<void> loadPlaceDetails(String placeId) async {
    print('🎯 PlaceDetailsCubit: Starting place details loading');

    // Emit loading state
    emit(PlaceDetailsLoading());
    print('📤 PlaceDetailsCubit: Emitted PlaceDetailsLoading\n');

    // Variable to track number of emissions from Stream
    int emissionCount = 0;

    // Listen to Stream
    print('👂 PlaceDetailsCubit: Listening to Stream from Repository...\n');

    repository
        .getPlaceDetails(placeId)
        .listen(
          (result) {
            emissionCount++;
            print(
              '📨 PlaceDetailsCubit: تم استقبال إرسال رقم $emissionCount من Stream',
            );
            print(
              '📨 PlaceDetailsCubit: Received emission #$emissionCount from Stream\n',
            );

            // Process result
            result.fold(
              (failure) {
                print('❌ PlaceDetailsCubit: Received error');
                print('📝 الخطأ - Error: ${failure.errMessage}\n');

                // Determine error type
                PlaceDetailsErrorType errorType = PlaceDetailsErrorType.general;

                if (failure.errMessage.contains('No internet') ||
                    failure.errMessage.contains('لا يوجد اتصال')) {
                  errorType = PlaceDetailsErrorType.noInternet;
                } else if (failure.errMessage.contains('not found') ||
                    failure.errMessage.contains('غير موجود')) {
                  errorType = PlaceDetailsErrorType.notFound;
                } else if (failure.errMessage.contains('Server') ||
                    failure.errMessage.contains('خادم')) {
                  errorType = PlaceDetailsErrorType.serverError;
                }

                // إرسال حالة الخطأ
                // Emit error state
                emit(PlaceDetailsError(failure: failure, errorType: errorType));

                print('📤 PlaceDetailsCubit: تم إرسال PlaceDetailsError');
                print('📤 PlaceDetailsCubit: Emitted PlaceDetailsError');
                print('📊 نوع الخطأ - Error type: $errorType\n');
              },

              // في حالة النجاح - On success
              (details) {
                print('✅ PlaceDetailsCubit: تم استقبال تفاصيل المكان');
                print('✅ PlaceDetailsCubit: Received place details');
                print('📝 اسم المكان - Place name: ${details['name']}\n');

                // تحديد ما إذا كانت البيانات من الكاش
                // Determine if data is from cache
                final bool isFromCache =
                    emissionCount == 1; // الإرسال الأول غالباً من الكاش
                // First emission is usually from cache

                // إرسال حالة النجاح
                // Emit success state
                emit(
                  PlaceDetailsLoaded(
                    details: details,
                    isFromCache: isFromCache,
                    message:
                        isFromCache
                            ? 'البيانات من الكاش المحلي\nData from local cache'
                            : null,
                  ),
                );

                print('📤 PlaceDetailsCubit: تم إرسال PlaceDetailsLoaded');
                print('📤 PlaceDetailsCubit: Emitted PlaceDetailsLoaded');
                print('📊 من الكاش - From cache: $isFromCache\n');
              },
            );
          },
          onError: (error) {
            // في حالة حدوث خطأ في Stream نفسه
            // In case of error in Stream itself
            print('❌ PlaceDetailsCubit: خطأ في Stream: $error');
            print('❌ PlaceDetailsCubit: Stream error: $error\n');

            emit(
              PlaceDetailsError(
                failure: ServerFailure(
                  errMessage: 'حدث خطأ غير متوقع\nUnexpected error occurred',
                ),
                errorType: PlaceDetailsErrorType.general,
              ),
            );
          },
          onDone: () {
            // When Stream completes
            print('✅ PlaceDetailsCubit: Stream completed');
            print('📊 عدد الإرسالات الكلي - Total emissions: $emissionCount\n');
          },
        );
  }

  Future<void> reload(String placeId) async {
    print('Reloading place details...\n');

    await loadPlaceDetails(placeId);
  }

  void reset() {
    print('Resetting PlaceDetailsCubit state\n');

    emit(PlaceDetailsInitial());
  }
}
