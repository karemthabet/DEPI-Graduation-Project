import 'package:hive/hive.dart';

part 'search_cache_model.g.dart';

@HiveType(typeId: 40)
class SearchCacheModel extends HiveObject {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final List<dynamic> predictionsJson;

  @HiveField(2)
  final DateTime cachedAt;

  SearchCacheModel({
    required this.query,
    required this.predictionsJson,
    required this.cachedAt,
  });

  bool get isExpired =>
      DateTime.now().difference(cachedAt).inHours >= 24;
}
