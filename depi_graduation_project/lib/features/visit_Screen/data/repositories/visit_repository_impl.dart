import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/visit_repository.dart';
import '../datasources/visit_remote_datasource.dart';
import '../model/place__model.dart';
import '../model/visit_date.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitRemoteDataSource remoteDataSource;

  VisitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VisitDate>> getAllVisitDates({String? userId}) async {
    return await remoteDataSource.getAllVisitDates(userId: userId);
  }

  @override
  Future<void> addPlaceToVisitDate({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  }) async {
    await remoteDataSource.addPlaceToVisitDate(
      place: place,
      visitDate: visitDate,
      userId: userId,
      visitTime: visitTime,
    );
  }

  @override
  Future<void> toggleVisitCompletion(int visitId, bool isCompleted) async {
    await remoteDataSource.toggleVisitCompletion(visitId, isCompleted);
  }

  @override
  Future<void> deleteVisit(int visitId) async {
    await remoteDataSource.deleteVisit(visitId);
  }

  @override
  Stream<List<VisitDate>> watchAllVisitDates({String? userId}) {
    return remoteDataSource.watchAllVisitDates(userId: userId);
  }
}
