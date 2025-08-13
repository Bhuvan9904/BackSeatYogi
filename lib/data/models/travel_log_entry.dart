import 'package:hive/hive.dart';
import 'travel_mode.dart';

part 'travel_log_entry.g.dart';

@HiveType(typeId: 6)
class TravelLogEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final String? destination;

  @HiveField(3)
  final String? companion;

  @HiveField(4)
  final TravelMode travelMode;

  @HiveField(5)
  final String? moodEmoji;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final String? practiceId;

  @HiveField(8)
  final int? sessionDuration;

  TravelLogEntry({
    required this.id,
    required this.createdAt,
    this.destination,
    this.companion,
    required this.travelMode,
    this.moodEmoji,
    this.notes,
    this.practiceId,
    this.sessionDuration,
  });

  factory TravelLogEntry.fromJson(Map<String, dynamic> json) {
    return TravelLogEntry(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      destination: json['destination'],
      companion: json['companion'],
      travelMode: TravelMode.values.firstWhere(
        (mode) => mode.name == json['travelMode'],
        orElse: () => TravelMode.general,
      ),
      moodEmoji: json['moodEmoji'],
      notes: json['notes'],
      practiceId: json['practiceId'],
      sessionDuration: json['sessionDuration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'destination': destination,
      'companion': companion,
      'travelMode': travelMode.name,
      'moodEmoji': moodEmoji,
      'notes': notes,
      'practiceId': practiceId,
      'sessionDuration': sessionDuration,
    };
  }
}
