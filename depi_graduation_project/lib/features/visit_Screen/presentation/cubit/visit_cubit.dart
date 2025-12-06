import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/visit_repository.dart';
import '../../data/model/place__model.dart';
import '../../data/model/visit_date.dart';
import '../../data/model/visit_items.dart';
import 'visit_state.dart';
import 'package:intl/intl.dart';
import '../../../../core/error/exceptions.dart';
import 'package:whatsapp/core/services/notification_service.dart';

class VisitCubit extends Cubit<VisitState> {
  final VisitRepository visitRepository;
  String? _lastNotificationDate;
  // ignore: cancel_subscriptions
  StreamSubscription<List<VisitDate>>? _visitSubscription;

  VisitCubit({required this.visitRepository}) : super(VisitInitial());

  void loadVisits() {
    emit(VisitLoading());
    final userId = Supabase.instance.client.auth.currentUser?.id;
    _visitSubscription?.cancel();
    _visitSubscription = visitRepository
        .watchAllVisitDates(userId: userId)
        .listen(
          (visitDates) {
            DateTime selectedDate = DateTime.now();
            if (state is VisitLoaded) {
              selectedDate = (state as VisitLoaded).selectedDate;
            }

            final filteredVisits = _getVisitsForDate(visitDates, selectedDate);

            emit(
              VisitLoaded(
                visitDates: visitDates,
                selectedDate: selectedDate,
                filteredVisits: filteredVisits,
              ),
            );

            _checkAndNotifyTodayVisits(visitDates);
          },
          onError: (error) {
            emit(VisitError(error.toString()));
          },
        );
  }

  // ... (selectDate, _getVisitsForDate, _checkAndNotifyTodayVisits remain same)

  void selectDate(DateTime date) {
    if (state is VisitLoaded) {
      final currentState = state as VisitLoaded;
      // Normalize date to start of day
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final filteredVisits = _getVisitsForDate(
        currentState.visitDates,
        normalizedDate,
      );

      emit(
        currentState.copyWith(
          selectedDate: normalizedDate,
          filteredVisits: filteredVisits,
        ),
      );
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

  void _checkAndNotifyTodayVisits(List<VisitDate> visitDates) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (_lastNotificationDate == todayStr) return;

    final todayVisits =
        visitDates
            .where(
              (vd) =>
                  DateFormat('yyyy-MM-dd').format(vd.date) == todayStr &&
                  vd.visits.isNotEmpty,
            )
            .toList();

    if (todayVisits.isNotEmpty) {
      final count = todayVisits.first.visits.length;
      NotificationService().showNotification(
        id: 1,
        title: 'You have visits today!',
        body: 'You have $count places to visit today. Check them out!',
      );
      _lastNotificationDate = todayStr;
    }
  }

  Future<void> addVisit({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  }) async {
    try {
      await visitRepository.addPlaceToVisitDate(
        place: place,
        visitDate: visitDate,
        userId: userId,
        visitTime: visitTime,
      );
    } on NetworkException catch (e) {
      emit(VisitError(e.message));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }

  Future<void> toggleCompletion(int visitId, bool isCompleted) async {
    try {
      await visitRepository.toggleVisitCompletion(visitId, isCompleted);
    } on NetworkException catch (e) {
      emit(VisitError(e.message));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }

  Future<void> deleteVisit(int visitId) async {
    try {
      await visitRepository.deleteVisit(visitId);
    } on NetworkException catch (e) {
      emit(VisitError(e.message));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _visitSubscription?.cancel();
    return super.close();
  }
}
