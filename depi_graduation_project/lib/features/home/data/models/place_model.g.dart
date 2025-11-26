// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceModelAdapter extends TypeAdapter<PlaceModel> {
  @override
  final int typeId = 1;

  @override
  PlaceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceModel(
      name: fields[0] as String,
      vicinity: fields[1] as String,
      rating: fields[2] as double?,
      category: fields[3] as String,
      placeId: fields[4] as String,
      photoReference: fields[5] as String?,
      lat: fields[6] as double,
      lng: fields[7] as double,
      formattedAddress: fields[9] as String?,
      description: fields[10] as String?,
      reviews: (fields[11] as List?)?.cast<ReviewModel>(),
      openingHours: fields[8] as OpeningHours?,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.vicinity)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.placeId)
      ..writeByte(5)
      ..write(obj.photoReference)
      ..writeByte(6)
      ..write(obj.lat)
      ..writeByte(7)
      ..write(obj.lng)
      ..writeByte(8)
      ..write(obj.openingHours)
      ..writeByte(9)
      ..write(obj.formattedAddress)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.reviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OpeningHoursAdapter extends TypeAdapter<OpeningHours> {
  @override
  final int typeId = 2;

  @override
  OpeningHours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OpeningHours(
      openNow: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OpeningHours obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.openNow);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpeningHoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewModelAdapter extends TypeAdapter<ReviewModel> {
  @override
  final int typeId = 3;

  @override
  ReviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewModel(
      authorName: fields[0] as String,
      text: fields[1] as String,
      rating: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.authorName)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
