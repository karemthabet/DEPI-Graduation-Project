// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_top_recommendations_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedTopRecommendationsModelAdapter
    extends TypeAdapter<CachedTopRecommendationsModel> {
  @override
  final int typeId = 11;

  @override
  CachedTopRecommendationsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedTopRecommendationsModel(
      topPlaces: (fields[0] as List).cast<PlaceModel>(),
      timestamp: fields[1] as DateTime,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CachedTopRecommendationsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.topPlaces)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedTopRecommendationsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
