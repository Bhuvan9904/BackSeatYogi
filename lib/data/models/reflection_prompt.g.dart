// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_prompt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReflectionPromptAdapter extends TypeAdapter<ReflectionPrompt> {
  @override
  final int typeId = 8;

  @override
  ReflectionPrompt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReflectionPrompt(
      id: fields[0] as String,
      question: fields[1] as String,
      category: fields[2] as String,
      order: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReflectionPrompt obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReflectionPromptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodTagAdapter extends TypeAdapter<MoodTag> {
  @override
  final int typeId = 9;

  @override
  MoodTag read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoodTag.calm;
      case 1:
        return MoodTag.focused;
      case 2:
        return MoodTag.relaxed;
      case 3:
        return MoodTag.grateful;
      case 4:
        return MoodTag.energized;
      case 5:
        return MoodTag.peaceful;
      case 6:
        return MoodTag.distracted;
      case 7:
        return MoodTag.anxious;
      case 8:
        return MoodTag.tired;
      case 9:
        return MoodTag.restless;
      default:
        return MoodTag.calm;
    }
  }

  @override
  void write(BinaryWriter writer, MoodTag obj) {
    switch (obj) {
      case MoodTag.calm:
        writer.writeByte(0);
        break;
      case MoodTag.focused:
        writer.writeByte(1);
        break;
      case MoodTag.relaxed:
        writer.writeByte(2);
        break;
      case MoodTag.grateful:
        writer.writeByte(3);
        break;
      case MoodTag.energized:
        writer.writeByte(4);
        break;
      case MoodTag.peaceful:
        writer.writeByte(5);
        break;
      case MoodTag.distracted:
        writer.writeByte(6);
        break;
      case MoodTag.anxious:
        writer.writeByte(7);
        break;
      case MoodTag.tired:
        writer.writeByte(8);
        break;
      case MoodTag.restless:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
