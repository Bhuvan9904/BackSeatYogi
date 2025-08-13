import 'package:hive/hive.dart';
import 'travel_mode.dart';

part 'practice.g.dart';

@HiveType(typeId: 1)
class Practice extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<int> availableDurations;

  @HiveField(4)
  final List<TravelMode> compatibleModes;

  @HiveField(5)
  final String audioUrl;

  @HiveField(6)
  final Map<int, String> practiceTextByDuration;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final String? shortDescription;

  Practice({
    required this.id,
    required this.title,
    required this.description,
    required this.availableDurations,
    required this.compatibleModes,
    required this.audioUrl,
    required this.practiceTextByDuration,
    required this.category,
    this.shortDescription,
  });

  // Helper methods
  String getPracticeText(int duration) {
    return practiceTextByDuration[duration] ?? practiceTextByDuration.values.first;
  }

  bool isCompatibleWith(TravelMode mode) {
    return compatibleModes.contains(mode) || compatibleModes.contains(TravelMode.general);
  }

  int get defaultDuration => availableDurations.first;

  // Keep JSON methods for backward compatibility
  factory Practice.fromJson(Map<String, dynamic> json) {
    return Practice(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      availableDurations: List<int>.from(json['availableDurations'] ?? [5]),
      compatibleModes: (json['compatibleModes'] as List<dynamic>?)?.map((e) => 
        TravelMode.values.firstWhere((mode) => mode.name == e, orElse: () => TravelMode.general)
      ).toList() ?? [TravelMode.general],
      audioUrl: json['audioUrl'],
      practiceTextByDuration: Map<int, String>.from(json['practiceTextByDuration'] ?? {5: json['practiceText'] ?? ''}),
      category: json['category'] ?? 'general',
      shortDescription: json['shortDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'availableDurations': availableDurations,
      'compatibleModes': compatibleModes.map((e) => e.name).toList(),
      'audioUrl': audioUrl,
      'practiceTextByDuration': practiceTextByDuration,
      'category': category,
      'shortDescription': shortDescription,
    };
  }
}
