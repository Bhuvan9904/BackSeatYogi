class AppConstants {
  // App Info
  static const String appName = 'Backseat Yogi';
  static const String appVersion = '1.0.0';

  // Practice Types
  static const List<String> practiceTypes = [
    'Mindful Breath',
    'Body Scan for Travelers',
    'Travel Gratitude',
    'Pre-Meeting Grounding',
    'Let Go of the Rush',
  ];

  // Session Durations (in minutes)
  static const List<int> sessionDurations = [2, 5, 10];

  // Travel Types
  static const List<String> travelTypes = ['Car', 'Train', 'Flight'];
  
  // Traveler Types
  static const List<String> travelerTypes = [
    'Commuter',
    'Business Traveler',
    'Leisure Traveler',
    'Student',
    'Explorer',
    'Digital Nomad',
    'Family Traveler',
  ];

  // Mood Tags
  static const List<String> moodTags = [
    'calm',
    'distracted',
    'focused',
    'anxious',
    'grateful',
    'tired',
  ];

  // Intentions
  static const List<String> intentions = [
    'Feel less anxious',
    'Be present',
    'Find calm',
    'Stay focused',
    'Practice gratitude',
    'Let go of stress',
  ];

  // Streak Messages
  static const Map<int, String> streakMessages = {
    3: 'Great start! You\'re building a mindful habit.',
    5: 'Excellent! You\'re finding your rhythm.',
    7: 'Amazing! A week of mindful travel.',
    14: 'Incredible! Two weeks of mindful practice.',
    30: 'Outstanding! A month of mindful journeys.',
  };

  // Badges
  static const Map<String, String> badges = {
    'Smooth Rider': 'Complete 5 car sessions',
    'Zen in Motion': 'Complete 10 train sessions',
    'Jet-Set Mindful': 'Complete 5 flight sessions',
    'Daily Warrior': '7-day streak',
    'Mindful Master': '30-day streak',
  };
}
