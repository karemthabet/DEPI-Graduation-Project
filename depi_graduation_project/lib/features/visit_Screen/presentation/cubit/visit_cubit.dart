import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/visit_repository.dart';
import '../../data/model/place__model.dart';
import '../../data/model/visit_date.dart';
import '../../data/model/visit_items.dart';
import 'visit_state.dart';
import 'package:intl/intl.dart';
import '../../../../core/errors/custom_exception.dart';
import 'package:whatsapp/core/services/notification_service.dart';
import '../../../../core/errors/server_failure.dart';

class VisitCubit extends Cubit<VisitState> {
  final VisitRepository visitRepository;

  StreamSubscription<List<VisitDate>>? _visitSubscription;

  VisitCubit({required this.visitRepository}) : super(VisitInitial());

  void loadVisits({bool showLoading = true}) {
    if (showLoading) {
      emit(VisitLoading());
    }
    final userId = Supabase.instance.client.auth.currentUser?.id;
    _visitSubscription?.cancel();
    _visitSubscription = visitRepository.watchAllVisitDates(userId: userId).listen(
      (visitDates) {
        DateTime selectedDate = DateTime.now();
        if (state is VisitLoaded) {
          selectedDate = (state as VisitLoaded).selectedDate;
        }

        final filteredVisits = _getVisitsForDate(visitDates, selectedDate);

        emit(VisitLoaded(
          visitDates: visitDates,
          selectedDate: selectedDate,
          filteredVisits: filteredVisits,
        ));
        
        _scheduleFutureNotifications(visitDates);
      },
      onError: (error) {
        if (error is NetworkException) {
          emit(VisitError(ServerFailure(errMessage: error.message)));
        } else {
          emit(VisitError(ServerFailure(errMessage: 'Error loading visits')));
        }
      },
    );
  }


  void selectDate(DateTime date) {
    if (state is VisitLoaded) {
      final currentState = state as VisitLoaded;
      // Normalize date to start of day
      final normalizedDate = DateTime(date.year, date.month, date.day);
      
      final filteredVisits = _getVisitsForDate(currentState.visitDates, normalizedDate);
      
      emit(currentState.copyWith(
        selectedDate: normalizedDate,
        filteredVisits: filteredVisits,
      ));
    }
  }

  List<VisitItem> _getVisitsForDate(List<VisitDate> visitDates, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final visitDateObj = visitDates.firstWhere(
      (vd) => DateFormat('yyyy-MM-dd').format(vd.date) == dateStr,
      orElse: () => VisitDate(id: -1, date: date, visits: []),
    );
    return visitDateObj.visits;
  }

  void _scheduleFutureNotifications(List<VisitDate> visitDates) {
    for (final visitDate in visitDates) {
      final int notificationId = visitDate.date.year * 10000 +
          visitDate.date.month * 100 +
          visitDate.date.day;

      if (visitDate.visits.isEmpty) {
        NotificationService().cancelNotification(notificationId);
        continue;
      }

      final count = visitDate.visits.length;
      NotificationService().scheduleNotification(
        id: notificationId,
        title: 'You have visits today!',
        body: 'You have $count places to visit today. Check them out!',
        scheduledDate: visitDate.date,
      );
    }
  }

  Future<void> addVisit({
    required Place place,
    required DateTime visitDate,
    String? visitTime,
  }) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
          emit(VisitError(ServerFailure(errMessage: 'User not logged in')));
          return;
      }
      
      await visitRepository.addPlaceToVisitDate(
        place: place,
        visitDate: visitDate,
        userId: userId,
        visitTime: visitTime,
      );
      loadVisits(showLoading: false);
    } on NetworkException catch (e) {
      emit(VisitError(ServerFailure(errMessage: e.message)));
    } catch (e) {
      emit(VisitError(ServerFailure(errMessage: 'Error adding visit')));
    }
  }

  Future<void> toggleCompletion(int visitId, bool isCompleted) async {
    try {
      await visitRepository.toggleVisitCompletion(visitId, isCompleted);
      loadVisits(showLoading: false); 
    } on NetworkException catch (e) {
      emit(VisitError(ServerFailure(errMessage: e.message)));
    } catch (e) {
      emit(VisitError(ServerFailure(errMessage: 'Error updating visit')));
    }
  }

  Future<void> deleteVisit(int visitId) async {
    try {
      await visitRepository.deleteVisit(visitId);
    } on NetworkException catch (e) {
      emit(VisitError(ServerFailure(errMessage: e.message)));
    } catch (e) {
      emit(VisitError(ServerFailure(errMessage: 'Error deleting visit')));
    }
  }

  Future<void> updateTime(int visitId, String newTime) async {
    try {
      await visitRepository.updateVisitTime(visitId, newTime);
      loadVisits(showLoading: false); 
    } on NetworkException catch (e) {
      emit(VisitError(ServerFailure(errMessage: e.message)));
    } catch (e) {
      emit(VisitError(ServerFailure(errMessage: 'Error updating visit')));
    }
  }

  @override
  Future<void> close() {
    _visitSubscription?.cancel();
    return super.close();
  }
}
