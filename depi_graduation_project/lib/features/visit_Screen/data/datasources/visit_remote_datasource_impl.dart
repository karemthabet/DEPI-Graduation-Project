import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/error/exceptions.dart';
import '../model/place__model.dart';
import '../model/visit_date.dart';
import '../model/visit_items.dart';
import 'visit_remote_datasource.dart';

class VisitRemoteDataSourceImpl implements VisitRemoteDataSource {
  final SupabaseClient supabase;

  VisitRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<VisitDate>> getAllVisitDates({String? userId}) async {
    try {
      var query = supabase
          .from('visit_date')
          .select('*, visitlist(*)');
      
      final response = await query.order('date', ascending: false);

      final data = response as List<dynamic>;
      var visits = data.map((e) => VisitDate.fromJson(e)).toList();
      
      if (userId != null) {
        visits = visits.map((date) {
          final userVisits = date.visits.where((v) => 
            true
          ).toList();
          return VisitDate(id: date.id, date: date.date, visits: userVisits);
        }).toList();
      }
      
      return visits;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> addPlaceToVisitDate({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  }) async {
    try {
      final visitDateId = await _getOrCreateVisitDate(visitDate);

      await supabase.from('visitlist').insert({
        'place_id': place.id,
        'placename': place.name,
        'adress': place.address, // Schema has 'adress'
        'image_url': place.imageUrl,
        'rating': place.rating,
        'visited_date_id': visitDateId, // Schema has 'visited_date_id'
        'user_id': userId,
        'visit_time': visitTime,
        'iscompleted': false,
        'place_data': place.toJson(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> toggleVisitCompletion(int visitId, bool isCompleted) async {
    try {
      await supabase
          .from('visitlist')
          .update({'iscompleted': isCompleted}).eq('id', visitId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> deleteVisit(int visitId) async {
    try {
      await supabase.from('visitlist').delete().eq('id', visitId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Stream<List<VisitDate>> watchAllVisitDates({String? userId}) {
    final datesStream = supabase
        .from('visit_date')
        .stream(primaryKey: ['id'])
        .order('date', ascending: false);

    dynamic visitsQuery = supabase.from('visitlist').stream(primaryKey: ['id']);
    if (userId != null) {
      visitsQuery = visitsQuery.eq('user_id', userId);
    }

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<VisitDate>>(
      datesStream,
      visitsQuery,
      (datesData, visitsData) {
        final visitsByDateId = <int, List<VisitItem>>{};
        
        for (final visitMap in visitsData) {
          final visit = VisitItem.fromJson(visitMap);
          final dateId = visitMap['visited_date_id'] as int;
          
          if (!visitsByDateId.containsKey(dateId)) {
            visitsByDateId[dateId] = [];
          }
          visitsByDateId[dateId]!.add(visit);
        }

        return datesData.map((dateMap) {
          final dateId = dateMap['id'] as int;
          final dateVisits = visitsByDateId[dateId] ?? [];
          
          return VisitDate(
            id: dateId,
            date: DateTime.parse(dateMap['date']),
            visits: dateVisits,
          );
        }).where((date) {
          if (userId != null) {
            return date.visits.isNotEmpty;
          }
          return true;
        }).toList();
      },
    ).handleError((error) {
      if (error is PostgrestException) {
        throw ServerException(error.message);
      } else {
        throw UnexpectedException(error.toString());
      }
    });
  }

  Future<int> _getOrCreateVisitDate(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      final existing = await supabase
          .from('visit_date')
          .select()
          .eq('date', dateStr)
          .maybeSingle();

      if (existing != null) {
        return existing['id'];
      }

      final newDate = await supabase
          .from('visit_date')
          .upsert({'date': dateStr}, onConflict: 'date')
          .select()
          .single();
          
      return newDate['id'];
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
