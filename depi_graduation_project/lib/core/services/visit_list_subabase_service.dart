import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/features/visit_Screen/data/model/place__model.dart';
import 'package:whatsapp/features/visit_Screen/data/model/visit_date.dart';

class VisitService {
  static final VisitService _instance = VisitService._internal();
  factory VisitService() => _instance;
  VisitService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// 1. جلب أو إنشاء تاريخ الزيارة
  Future<int> getOrCreateVisitDate(DateTime date) async {
    // نحول التاريخ إلى نص بصيغة YYYY-MM-DD للبحث عنه
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    // محاولة البحث عن التاريخ
    final existing =
        await _supabase
            .from('visit_date')
            .select()
            .eq('visit_date', dateStr)
            .maybeSingle();

    if (existing != null) {
      return existing['id'];
    } else {
      // إذا لم يكن موجوداً، نقوم بإنشائه
      final newDate =
          await _supabase
              .from('visit_date')
              .insert({'visit_date': dateStr})
              .select()
              .single();
      return newDate['id'];
    }
  }

  /// 2. إضافة مكان للزيارات
  Future<void> addPlaceToVisitDate({
    required Place place,
    required DateTime visitDate,
    required String userId,
    String? visitTime,
  }) async {
    // أولاً: نحصل على معرف التاريخ (موجود أو جديد)
    final visitDateId = await getOrCreateVisitDate(visitDate);

    // ثانياً: نضيف الزيارة في جدول visitlist
    await _supabase.from('visitlist').insert({
      'place_id': place.id,
      'placename': place.name,
      'address': place.address,
      'image_url': place.imageUrl,
      'rating': place.rating,
      'visit_date_id': visitDateId,
      'user_id': userId,
      'visit_time': visitTime,
      'is_completed': false,
      'place_data': place.toJson(), // تخزين الـ JSON كامل
    });
  }

  /// 3. جلب كل التواريخ مع الزيارات (Query عادي)
  Future<List<VisitDate>> getAllVisitDates() async {
    // نستخدم select مع العلاقة لجلب الزيارات داخل كل تاريخ
    // ملاحظة: تأكد من وجود Foreign Key في Supabase ليعمل هذا الاستعلام
    final response = await _supabase
        .from('visit_date')
        .select('*, visitlist(*)')
        .order('visit_date', ascending: false); // الأحدث أولاً

    final data = response as List<dynamic>;
    return data.map((e) => VisitDate.fromJson(e)).toList();
  }

  /// 4. تحديث حالة الإنجاز
  Future<void> toggleVisitCompletion(int visitId, bool isCompleted) async {
    await _supabase
        .from('visitlist')
        .update({'is_completed': isCompleted})
        .eq('id', visitId);
  }

  /// 5. حذف زيارة
  Future<void> deleteVisit(int visitId) async {
    await _supabase.from('visitlist').delete().eq('id', visitId);
  }

  /// 6. Stream للتحديثات الفورية
  /// بما أن stream في Supabase لا يدعم الـ Joins العميقة بشكل مباشر في الـ payload،
  /// سنقوم بالاستماع للتغييرات في جدول visitlist، وعند حدوث أي تغيير نعيد جلب البيانات كاملة.
  Stream<List<VisitDate>> watchAllVisitDates() async* {
    // إرسال البيانات الحالية فوراً
    yield await getAllVisitDates();

    // الاستماع للتغييرات
    final stream = _supabase.from('visitlist').stream(primaryKey: ['id']);

    // عند كل تغيير في الجدول، نعيد جلب القائمة كاملة ومرتبة
    await for (final _ in stream) {
      yield await getAllVisitDates();
    }
  }
}
