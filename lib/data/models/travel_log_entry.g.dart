// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_log_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelLogEntryAdapter extends TypeAdapter<TravelLogEntry> {
  @override
  final int typeId = 6;

  @override
  TravelLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelLogEntry(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      destination: fields[2] as String?,
      companion: fields[3] as String?,
      travelMode: fields[4] as TravelMode,
      moodEmoji: fields[5] as String?,
      notes: fields[6] as String?,
      practiceId: fields[7] as String?,
      sessionDuration: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TravelLogEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.companion)
      ..writeByte(4)
      ..write(obj.travelMode)
      ..writeByte(5)
      ..write(obj.moodEmoji)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.practiceId)
      ..writeByte(8)
      ..write(obj.sessionDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
