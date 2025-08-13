import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/hive_storage_service.dart';
import '../core/services/alarm_service.dart';
import '../data/models/user_preferences.dart';

class AppProvider extends ChangeNotifier {
  UserPreferences? _userPreferences;
  bool _isLoading = true;

  // Getters
  bool get isFirstLaunch {
    // If still loading, assume it's first launch to show onboarding
    if (_isLoading) return true;
    return _userPreferences?.isFirstLaunch ?? true;
  }
  String get userIntention => _userPreferences?.userIntention ?? '';
  String get travelerType => _userPreferences?.travelerType ?? '';
  bool get remindersEnabled => _userPreferences?.remindersEnabled ?? true;
  String get reminderTime => _userPreferences?.reminderTime ?? '08:00';
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadUserPreferences();
  }

  // Method to wait for preferences to load
  Future<void> waitForPreferences() async {
    while (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      _userPreferences = await HiveStorageService.getUserPreferences();
      _isLoading = false;
      notifyListeners();
      
      // Reschedule notifications when app starts
      await _rescheduleNotificationsOnAppStart();
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
      _userPreferences = UserPreferences();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _rescheduleNotificationsOnAppStart() async {
    try {
      if (_userPreferences != null && _userPreferences!.remindersEnabled && _userPreferences!.reminderTime.isNotEmpty) {
        debugPrint('Rescheduling alarms on app start');
        await _scheduleReminders();
      }
    } catch (e) {
      debugPrint('Error rescheduling alarms on app start: $e');
    }
  }

  Future<void> _saveUserPreferences() async {
    if (_userPreferences != null) {
      try {
        await HiveStorageService.saveUserPreferences(_userPreferences!);
      } catch (e) {
        debugPrint('Error saving user preferences: $e');
      }
    }
  }

  // Setters
  Future<void> setFirstLaunch(bool value) async {
    _userPreferences ??= UserPreferences();
    _userPreferences!.isFirstLaunch = value;
    await _saveUserPreferences();
    notifyListeners();
  }

  Future<void> setUserIntention(String intention) async {
    _userPreferences ??= UserPreferences();
    _userPreferences!.userIntention = intention;
    await _saveUserPreferences();
    notifyListeners();
  }

  Future<void> setTravelerType(String type) async {
    _userPreferences ??= UserPreferences();
    _userPreferences!.travelerType = type;
    await _saveUserPreferences();
    notifyListeners();
  }

  Future<void> updateReminderSettings({bool? enabled, String? time}) async {
    _userPreferences ??= UserPreferences();

    if (enabled != null) _userPreferences!.remindersEnabled = enabled;
    if (time != null) _userPreferences!.reminderTime = time;

    await _saveUserPreferences();
    
    // Add debugging information
    debugPrint('=== REMINDER SETTINGS UPDATED ===');
    debugPrint('Enabled: ${_userPreferences!.remindersEnabled}');
    debugPrint('Time: ${_userPreferences!.reminderTime}');
    
    await _scheduleReminders();
    notifyListeners();
  }

  Future<void> _scheduleReminders() async {
    try {
      debugPrint('=== SCHEDULING ALARMS ===');
      
      // Cancel existing alarms first
      await AlarmService().cancelAlarm();
      debugPrint('Cancelled all existing alarms');
      
      if (!_userPreferences!.remindersEnabled) {
        debugPrint('❌ Alarms disabled, cancelling all alarms');
        return;
      }

      // Schedule daily alarm if time is set
      if (_userPreferences!.reminderTime.isNotEmpty) {
        final timeParts = _userPreferences!.reminderTime.split(':');
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]) ?? 8;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          
          debugPrint('⏰ Setting alarm for $hour:$minute');
          
          // Schedule alarm
          try {
            await AlarmService().scheduleDailyAlarm(
              hour: hour,
              minute: minute,
            );
            
            debugPrint('✅ Daily alarm scheduled successfully');
            
          } catch (e) {
            debugPrint('❌ Error scheduling alarm: $e');
          }
        } else {
          debugPrint('❌ Invalid time format: ${_userPreferences!.reminderTime}');
        }
      } else {
        debugPrint('❌ No alarm time set');
      }
    } catch (e) {
      debugPrint('❌ Error scheduling alarms: $e');
    }
  }



  // Reset app state (for testing)
  Future<void> reset() async {
    _userPreferences = UserPreferences();
    await _saveUserPreferences();
    notifyListeners();
  }

  // Manually reschedule alarms (for testing)
  Future<void> rescheduleNotifications() async {
    try {
      debugPrint('Manually rescheduling alarms');
      await _scheduleReminders();
    } catch (e) {
      debugPrint('Error manually rescheduling alarms: $e');
    }
  }
}
