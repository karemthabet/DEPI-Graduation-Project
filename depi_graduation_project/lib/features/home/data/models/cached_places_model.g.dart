// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_places_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedPlacesModelAdapter extends TypeAdapter<CachedPlacesModel> {
  @override
  final int typeId = 0;

  @override
  CachedPlacesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedPlacesModel(
      lat: fields[0] as double,
      lng: fields[1] as double,
      places: (fields[2] as List).cast<PlaceModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CachedPlacesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng)
      ..writeByte(2)
      ..write(obj.places);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedPlacesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
