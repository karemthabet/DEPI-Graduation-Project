import '../../data/model/visit_date.dart';
import '../../data/model/visit_items.dart';
import '../../../../core/errors/server_failure.dart';

abstract class VisitState {}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitLoaded extends VisitState {
  final List<VisitDate> visitDates;
  final DateTime selectedDate;
  final List<VisitItem> filteredVisits;

  VisitLoaded({
    required this.visitDates,
    required this.selectedDate,
    required this.filteredVisits,
  });

  VisitLoaded copyWith({
    List<VisitDate>? visitDates,
    DateTime? selectedDate,
    List<VisitItem>? filteredVisits,
  }) {
    return VisitLoaded(
      visitDates: visitDates ?? this.visitDates,
      selectedDate: selectedDate ?? this.selectedDate,
      filteredVisits: filteredVisits ?? this.filteredVisits,
    );
  }
}



class VisitError extends VisitState {
  final Failure failure;
  VisitError(this.failure);
}
