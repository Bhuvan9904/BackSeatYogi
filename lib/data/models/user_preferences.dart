import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 2)
class UserPreferences extends HiveObject {
  @HiveField(0)
  bool isFirstLaunch;

  @HiveField(1)
  String travelerType;

  @HiveField(2)
  String userIntention;

  @HiveField(3)
  bool remindersEnabled;

  @HiveField(4)
  String reminderTime;

  UserPreferences({
    this.isFirstLaunch = true,
    this.travelerType = '',
    this.userIntention = '',
    this.remindersEnabled = true,
    this.reminderTime = '08:00',
  });

  Map<String, dynamic> toJson() {
    return {
      'isFirstLaunch': isFirstLaunch,
      'travelerType': travelerType,
      'userIntention': userIntention,
      'remindersEnabled': remindersEnabled,
      'reminderTime': reminderTime,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isFirstLaunch: json['isFirstLaunch'] ?? true,
      travelerType: json['travelerType'] ?? '',
      userIntention: json['userIntention'] ?? '',
      remindersEnabled: json['remindersEnabled'] ?? true,
      reminderTime: json['reminderTime'] ?? '08:00',
    );
  }
}
