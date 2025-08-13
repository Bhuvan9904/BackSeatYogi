import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/travel_log.dart';

class StorageService {
  static const String _travelLogsKey = 'travel_logs';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _streakDataKey = 'streak_data';

  // Travel Logs
  Future<List<TravelLog>> getTravelLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getStringList(_travelLogsKey) ?? [];

    return logsJson.map((json) => TravelLog.fromJson(jsonDecode(json))).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveTravelLog(TravelLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await getTravelLogs();
    logs.add(log);

    final logsJson = logs.map((log) => jsonEncode(log.toJson())).toList();
    await prefs.setStringList(_travelLogsKey, logsJson);
  }

  Future<void> deleteTravelLog(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await getTravelLogs();
    logs.removeWhere((log) => log.id == id);

    final logsJson = logs.map((log) => jsonEncode(log.toJson())).toList();
    await prefs.setStringList(_travelLogsKey, logsJson);
  }

  // User Preferences
  Future<Map<String, dynamic>> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsJson = prefs.getString(_userPreferencesKey);

    if (prefsJson != null) {
      return jsonDecode(prefsJson);
    }

    return {
      'isFirstLaunch': true,
      'travelerType': '',
      'userIntention': '',
      'remindersEnabled': true,
      'reminderTime': '08:00',
    };
  }

  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPreferencesKey, jsonEncode(preferences));
  }

  // Streak Data
  Future<Map<String, dynamic>> getStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    final streakJson = prefs.getString(_streakDataKey);

    if (streakJson != null) {
      return jsonDecode(streakJson);
    }

    return {
      'currentStreak': 0,
      'longestStreak': 0,
      'totalSessions': 0,
      'lastPracticeDate': null,
      'completedDays': [],
    };
  }

  Future<void> saveStreakData(Map<String, dynamic> streakData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_streakDataKey, jsonEncode(streakData));
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
