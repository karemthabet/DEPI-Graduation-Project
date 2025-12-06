import '../../data/datasources/visit_remote_datasource.dart';
import '../../data/model/place__model.dart';
import '../../data/model/visit_date.dart';

import '../../domain/repositories/visit_repository.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitRemoteDataSource remoteDataSource;

  VisitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addPlaceToVisitDate({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  }) async {
    return await remoteDataSource.addPlaceToVisitDate(
      place: place,
      visitDate: visitDate,
      userId: userId,
      visitTime: visitTime,
    );
  }

  @override
  Future<void> deleteVisit(int visitId) async {
    return await remoteDataSource.deleteVisit(visitId);
  }

  @override
  Future<List<VisitDate>> getAllVisitDates({String? userId}) async {
    return await remoteDataSource.getAllVisitDates(userId: userId);
  }

  @override
  Future<void> toggleVisitCompletion(int visitId, bool isCompleted) async {
    return await remoteDataSource.toggleVisitCompletion(visitId, isCompleted);
  }

  @override
  Stream<List<VisitDate>> watchAllVisitDates({String? userId}) {
    return remoteDataSource.watchAllVisitDates(userId: userId);
  }
}
