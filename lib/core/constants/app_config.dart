class AppConfig {
  // App Information
  static const String appName = 'Backseat Yogi';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'A minimalist wellness companion for mindful travel';

  // Developer Information
  static const String developerName = 'Backseat Yogi Team';
  static const String supportEmail = 'support@backseatyogi.com';
  static const String privacyPolicyUrl = 'https://backseatyogi.com/privacy';
  static const String termsOfServiceUrl = 'https://backseatyogi.com/terms';

  // App Store Information
  static const String appStoreId = 'com.backseatyogi.app';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.backseatyogi.app';
  static const String appStoreUrl =
      'https://apps.apple.com/app/backseat-yogi/id123456789';

  // Feature Flags
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
  static const bool enablePushNotifications = true;

  // Practice Settings
  static const int maxPracticesPerDay = 10;
  static const int maxReflectionsPerDay = 5;
  static const List<int> availableDurations = [2, 5, 10];

  // Reminder Settings
  static const List<String> defaultReminderTimes = ['08:00', '12:00', '18:00'];

  // Streak Settings
  static const Map<int, String> streakMilestones = {
    3: 'Getting Started',
    7: 'Week Warrior',
    14: 'Fortnight Focus',
    30: 'Monthly Master',
    100: 'Century Club',
  };
}
