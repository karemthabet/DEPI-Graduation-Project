import 'visit_items.dart';

class VisitDate {
  final int id;
  final DateTime date;
  final List<VisitItem> visits;

  VisitDate({
    required this.id,
    required this.date,
    this.visits = const [],
  });

  factory VisitDate.fromJson(Map<String, dynamic> json) {
    return VisitDate(
      id: json['id'],
      date: DateTime.parse(json['date']),
      visits: json['visitlist'] != null
          ? (json['visitlist'] as List).map((e) => VisitItem.fromJson(e)).toList()
          : [],
    );
  }

  double get completionProgress {
    if (visits.isEmpty) return 0.0;
    final completed = visits.where((v) => v.isCompleted).length;
    return completed / visits.length;
  }
}