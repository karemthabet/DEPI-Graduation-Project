import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/errors/custom_exception.dart';
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
      var query = supabase.from('visitlist').select();

      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      final response = await query.order('visit_date', ascending: false);
      final data = response as List<dynamic>;

      return _groupVisitsByDate(data);

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
      final dateStr = DateFormat('yyyy-MM-dd').format(visitDate);

      await supabase.from('visitlist').insert({
        'place_id': place.id,
        'placename': place.name,
        'address': place.address,
        'image_url': place.imageUrl,
        'rating': place.rating.toString(),
        'visit_date': dateStr,
        'user_id': userId,
        'visit_time': visitTime,
        'iscompleted': false,
      });
    } on PostgrestException catch (e) {
      print('Supabase Insert Error: ${e.message} - Code: ${e.code}'); 
      throw ServerException(e.message);
    } catch (e) {
      print('Unexpected Insert Error: $e'); 
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
  Future<void> updateVisitTime(int visitId, String visitTime) async {
    try {
      await supabase
          .from('visitlist')
          .update({'visit_time': visitTime}).eq('id', visitId);
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
  Stream<List<VisitDate>> watchAllVisitDates({String? userId}) async* {
    try {
      yield await getAllVisitDates(userId: userId);
    } catch (e) {
    }

    final visitStream = supabase.from('visitlist').stream(primaryKey: ['id']);

    await for (final _ in visitStream) {
      try {
        yield await getAllVisitDates(userId: userId);
      } catch (e) {
      }
    }
  }

  List<VisitDate> _groupVisitsByDate(List<dynamic> rawData) {
    final Map<String, List<VisitItem>> groupedVisits = {};

    for (var item in rawData) {
      final dateStr = item['visit_date'] as String?;
      if (dateStr == null) continue;

      final dateKey = dateStr.split('T').first;

      if (!groupedVisits.containsKey(dateKey)) {
        groupedVisits[dateKey] = [];
      }

      groupedVisits[dateKey]!.add(VisitItem.fromJson(item));
    }

    
    final List<VisitDate> visitDates = groupedVisits.entries.map((entry) {
      return VisitDate(
        id: -1, 
        date: DateTime.parse(entry.key),
        visits: entry.value,
      );
    }).toList();

    visitDates.sort((a, b) => b.date.compareTo(a.date));

    return visitDates;
  }
}

