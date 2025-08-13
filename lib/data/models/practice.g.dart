// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PracticeAdapter extends TypeAdapter<Practice> {
  @override
  final int typeId = 1;

  @override
  Practice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Practice(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      availableDurations: (fields[3] as List).cast<int>(),
      compatibleModes: (fields[4] as List).cast<TravelMode>(),
      audioUrl: fields[5] as String,
      practiceTextByDuration: (fields[6] as Map).cast<int, String>(),
      category: fields[7] as String,
      shortDescription: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Practice obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.availableDurations)
      ..writeByte(4)
      ..write(obj.compatibleModes)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.practiceTextByDuration)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.shortDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
