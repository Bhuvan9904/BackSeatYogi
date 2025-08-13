// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelLogAdapter extends TypeAdapter<TravelLog> {
  @override
  final int typeId = 0;

  @override
  TravelLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      destination: fields[2] as String,
      travelType: fields[3] as String,
      practiceId: fields[4] as String?,
      practiceName: fields[5] as String?,
      practiceDuration: fields[6] as int?,
      mood: fields[7] as String?,
      reflection: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TravelLog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.travelType)
      ..writeByte(4)
      ..write(obj.practiceId)
      ..writeByte(5)
      ..write(obj.practiceName)
      ..writeByte(6)
      ..write(obj.practiceDuration)
      ..writeByte(7)
      ..write(obj.mood)
      ..writeByte(8)
      ..write(obj.reflection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
