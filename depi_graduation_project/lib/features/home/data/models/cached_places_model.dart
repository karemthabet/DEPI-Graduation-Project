import 'package:hive/hive.dart';
import 'place_model.dart';

part 'cached_places_model.g.dart';

@HiveType(typeId: 0)
class CachedPlacesModel extends HiveObject {
  @HiveField(0)
  final double lat;

  @HiveField(1)
  final double lng;

  @HiveField(2)
  final List<PlaceModel> places;

  CachedPlacesModel({
    required this.lat,
    required this.lng,
    required this.places,
  });
}
