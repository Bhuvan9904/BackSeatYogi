// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelModeAdapter extends TypeAdapter<TravelMode> {
  @override
  final int typeId = 5;

  @override
  TravelMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TravelMode.car;
      case 1:
        return TravelMode.train;
      case 2:
        return TravelMode.flight;
      case 3:
        return TravelMode.general;
      default:
        return TravelMode.car;
    }
  }

  @override
  void write(BinaryWriter writer, TravelMode obj) {
    switch (obj) {
      case TravelMode.car:
        writer.writeByte(0);
        break;
      case TravelMode.train:
        writer.writeByte(1);
        break;
      case TravelMode.flight:
        writer.writeByte(2);
        break;
      case TravelMode.general:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
