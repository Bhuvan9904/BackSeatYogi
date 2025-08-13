import 'package:hive/hive.dart';

part 'streak_data.g.dart';

@HiveType(typeId: 3)
class StreakData extends HiveObject {
  @HiveField(0)
  int currentStreak;

  @HiveField(1)
  int longestStreak;

  @HiveField(2)
  int totalSessions;

  @HiveField(3)
  DateTime? lastPracticeDate;

  @HiveField(4)
  List<DateTime> completedDays;

  StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalSessions = 0,
    this.lastPracticeDate,
    List<DateTime>? completedDays,
  }) : completedDays = completedDays ?? [];

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalSessions': totalSessions,
      'lastPracticeDate': lastPracticeDate?.toIso8601String(),
      'completedDays': completedDays
          .map((date) => date.toIso8601String())
          .toList(),
    };
  }

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      totalSessions: json['totalSessions'] ?? 0,
      lastPracticeDate: json['lastPracticeDate'] != null
          ? DateTime.parse(json['lastPracticeDate'])
          : null,
      completedDays:
          (json['completedDays'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date))
              .toList() ??
          [],
    );
  }

  void addPracticeSession() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Add to completed days if not already there
    if (!completedDays.any(
      (date) =>
          date.year == todayDate.year &&
          date.month == todayDate.month &&
          date.day == todayDate.day,
    )) {
      completedDays.add(todayDate);
    }

    totalSessions++;
    lastPracticeDate = todayDate;

    // Update streaks
    _updateStreaks();
  }

  void _updateStreaks() {
    if (lastPracticeDate == null) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if practiced yesterday
    final yesterday = todayDate.subtract(const Duration(days: 1));
    final practicedYesterday = completedDays.any(
      (date) =>
          date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day,
    );

    if (practicedYesterday) {
      currentStreak++;
    } else {
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }
}
