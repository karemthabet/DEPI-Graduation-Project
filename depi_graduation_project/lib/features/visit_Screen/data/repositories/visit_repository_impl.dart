import 'package:dartz/dartz.dart';
import '../../../../core/errors/custom_exception.dart';
import '../../../../core/errors/server_failure.dart';
import '../../domain/repositories/visit_repository.dart';
import '../datasources/visit_remote_datasource.dart';
import '../model/place__model.dart';
import '../model/visit_date.dart';
import '../../../../core/services/network_checker.dart';
import '../../../../core/helper/app_logger.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitRemoteDataSource remoteDataSource;

  VisitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VisitDate>> getAllVisitDates({String? userId}) async {
    if (!await NetworkChecker.instance.isConnected()) {
      throw NetworkException('no internet :connection');
    }
    return await remoteDataSource.getAllVisitDates(userId: userId);
  }

  @override
  Future<void> addPlaceToVisitDate({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  }) async {
    if (!await NetworkChecker.instance.isConnected()) {
      throw NetworkException('no internet :connection');
    }
    await remoteDataSource.addPlaceToVisitDate(
      place: place,
      visitDate: visitDate,
      userId: userId,
      visitTime: visitTime,
    );
  }

  @override
  Future<void> toggleVisitCompletion(int visitId, bool isCompleted) async {
    if (!await NetworkChecker.instance.isConnected()) {
      throw NetworkException('no internet :connection');
    }
    await remoteDataSource.toggleVisitCompletion(visitId, isCompleted);
  }

  @override
  Future<void> deleteVisit(int visitId) async {
    if (!await NetworkChecker.instance.isConnected()) {
      throw NetworkException('no internet :connection');
    }
    await remoteDataSource.deleteVisit(visitId);
  }

  @override
  Future<void> updateVisitTime(int visitId, String visitTime) async {
    if (!await NetworkChecker.instance.isConnected()) {
      throw NetworkException('no internet :connection');
    }
    await remoteDataSource.updateVisitTime(visitId, visitTime);
  }

  @override
  Stream<List<VisitDate>> watchAllVisitDates({String? userId}) {
    return remoteDataSource.watchAllVisitDates(userId: userId);
  }
}
