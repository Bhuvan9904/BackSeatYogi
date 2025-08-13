import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'travel_log.g.dart';

@HiveType(typeId: 0)
class TravelLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String destination;

  @HiveField(3)
  final String travelType;

  @HiveField(4)
  final String? practiceId;

  @HiveField(5)
  final String? practiceName;

  @HiveField(6)
  final int? practiceDuration;

  @HiveField(7)
  final String? mood;

  @HiveField(8)
  final String? reflection;

  TravelLog({
    required this.id,
    required this.date,
    required this.destination,
    required this.travelType,
    this.practiceId,
    this.practiceName,
    this.practiceDuration,
    this.mood,
    this.reflection,
  });

  // Keep JSON methods for backward compatibility
  factory TravelLog.fromJson(Map<String, dynamic> json) {
    return TravelLog(
      id: json['id'],
      date: DateTime.parse(json['date']),
      destination: json['destination'],
      travelType: json['travelType'],
      practiceId: json['practiceId'],
      practiceName: json['practiceName'],
      practiceDuration: json['practiceDuration'],
      mood: json['mood'],
      reflection: json['reflection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'destination': destination,
      'travelType': travelType,
      'practiceId': practiceId,
      'practiceName': practiceName,
      'practiceDuration': practiceDuration,
      'mood': mood,
      'reflection': reflection,
    };
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';

    return DateFormat('MMM dd').format(date);
  }

  String get formattedTime {
    return DateFormat('h:mm a').format(date);
  }
}
