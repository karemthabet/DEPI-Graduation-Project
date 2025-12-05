import '../../data/model/place__model.dart';
import '../../data/model/visit_date.dart';

abstract class VisitRepository {
  Future<List<VisitDate>> getAllVisitDates({String? userId});
  Future<void> addPlaceToVisitDate({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  });
  Future<void> toggleVisitCompletion(int visitId, bool isCompleted);
  Future<void> deleteVisit(int visitId);
  Stream<List<VisitDate>> watchAllVisitDates({String? userId});
}
