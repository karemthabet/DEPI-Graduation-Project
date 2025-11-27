// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_categories_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedCategoriesModelAdapter extends TypeAdapter<CachedCategoriesModel> {
  @override
  final int typeId = 13;

  @override
  CachedCategoriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedCategoriesModel(
      categories: (fields[0] as Map).cast<String, String>(),
      timestamp: fields[1] as DateTime,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CachedCategoriesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.categories)
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
      other is CachedCategoriesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
