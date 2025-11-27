// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_place_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedPlaceDetailsModelAdapter
    extends TypeAdapter<CachedPlaceDetailsModel> {
  @override
  final int typeId = 12;

  @override
  CachedPlaceDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedPlaceDetailsModel(
      placeId: fields[0] as String,
      details: (fields[1] as Map).cast<String, dynamic>(),
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedPlaceDetailsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.placeId)
      ..writeByte(1)
      ..write(obj.details)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedPlaceDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
