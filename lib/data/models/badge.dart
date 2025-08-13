import 'package:hive/hive.dart';

part 'badge.g.dart';

@HiveType(typeId: 7)
class Badge extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String emoji;

  @HiveField(4)
  final int requiredStreak;

  @HiveField(5)
  final DateTime? unlockedAt;

  @HiveField(6)
  final bool isUnlocked;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requiredStreak,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  static List<Badge> getDefaultBadges() {
    return [
      Badge(
        id: 'first_ride',
        title: 'First Ride',
        description: 'Completed your first mindful journey',
        emoji: '🌟',
        requiredStreak: 1,
      ),
      Badge(
        id: 'smooth_rider',
        title: 'Smooth Rider',
        description: '3 days of mindful travel',
        emoji: '🚗',
        requiredStreak: 3,
      ),
      Badge(
        id: 'zen_in_motion',
        title: 'Zen in Motion',
        description: '5 days of consistent practice',
        emoji: '🧘‍♀️',
        requiredStreak: 5,
      ),
      Badge(
        id: 'mindful_week',
        title: 'Mindful Week',
        description: '7 days of travel mindfulness',
        emoji: '📅',
        requiredStreak: 7,
      ),
      Badge(
        id: 'jet_set_mindful',
        title: 'Jet-Set Mindful',
        description: '14 days of mindful journeys',
        emoji: '✈️',
        requiredStreak: 14,
      ),
      Badge(
        id: 'travel_sage',
        title: 'Travel Sage',
        description: '30 days of mindful travel',
        emoji: '🏆',
        requiredStreak: 30,
      ),
    ];
  }

  Badge copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? requiredStreak,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Badge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      requiredStreak: requiredStreak ?? this.requiredStreak,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
