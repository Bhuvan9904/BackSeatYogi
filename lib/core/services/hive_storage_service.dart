import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/travel_log.dart';
import '../../data/models/practice.dart';
import '../../data/models/user_preferences.dart';
import '../../data/models/streak_data.dart';
import '../../data/models/reflection_prompt.dart';

class HiveStorageService {
  static const String _travelLogsBox = 'travel_logs';
  static const String _practicesBox = 'practices';
  static const String _userPreferencesBox = 'user_preferences';
  static const String _streakDataBox = 'streak_data';
  static const String _reflectionPromptsBox = 'reflection_prompts';

  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Register adapters (only if not already registered)
      _registerAdapters();

      // Try to open boxes with migration/recovery
      await _openBoxesSafely();
      
    } catch (e) {
      print('Hive initialization error: $e');
      await _handleInitializationError(e);
    }
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TravelLogAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PracticeAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserPreferencesAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(StreakDataAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(ReflectionPromptAdapter());
    }
  }

  static Future<void> _openBoxesSafely() async {
    // Open boxes with individual error handling
    await _openBoxSafely<TravelLog>(_travelLogsBox);
    await _openBoxSafely<Practice>(_practicesBox);
    await _openBoxSafely<UserPreferences>(_userPreferencesBox);
    await _openBoxSafely<StreakData>(_streakDataBox);
    await _openBoxSafely<ReflectionPrompt>(_reflectionPromptsBox);
  }

  static Future<void> _openBoxSafely<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<T>(boxName);
      }
    } catch (e) {
      print('Error opening box $boxName: $e');
      // If there's a corruption or type mismatch, delete and recreate the box
      try {
        await Hive.deleteBoxFromDisk(boxName);
        await Hive.openBox<T>(boxName);
        print('Successfully recreated corrupted box: $boxName');
      } catch (deleteError) {
        print('Failed to recreate box $boxName: $deleteError');
        rethrow;
      }
    }
  }

  static Future<void> _handleInitializationError(dynamic error) async {
    try {
      // Close all connections
      await Hive.close();
      
      // Clear all existing data if there are persistent errors
      await _deleteAllBoxes();
      
      // Reinitialize from scratch
      await Hive.initFlutter();
      _registerAdapters();
      await _openBoxesSafely();
      
      print('Successfully recovered from initialization error');
    } catch (recoveryError) {
      print('Complete recovery failed: $recoveryError');
      rethrow;
    }
  }

  static Future<void> _deleteAllBoxes() async {
    try {
      await Hive.deleteBoxFromDisk(_travelLogsBox);
      await Hive.deleteBoxFromDisk(_practicesBox);
      await Hive.deleteBoxFromDisk(_userPreferencesBox);
      await Hive.deleteBoxFromDisk(_streakDataBox);
      await Hive.deleteBoxFromDisk(_reflectionPromptsBox);
    } catch (e) {
      // Ignore deletion errors - files might not exist
      print('Box deletion warning (can be ignored): $e');
    }
  }

  // Travel Logs
  static Future<List<TravelLog>> getTravelLogs() async {
    final box = Hive.box<TravelLog>(_travelLogsBox);
    final logs = box.values.toList();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }

  static Future<void> saveTravelLog(TravelLog log) async {
    final box = Hive.box<TravelLog>(_travelLogsBox);
    await box.put(log.id, log);
  }

  static Future<void> deleteTravelLog(String id) async {
    final box = Hive.box<TravelLog>(_travelLogsBox);
    await box.delete(id);
  }

  static Future<TravelLog?> getTravelLog(String id) async {
    final box = Hive.box<TravelLog>(_travelLogsBox);
    return box.get(id);
  }

  // Practices
  static Future<List<Practice>> getPractices() async {
    final box = Hive.box<Practice>(_practicesBox);
    return box.values.toList();
  }

  static Future<void> savePractice(Practice practice) async {
    final box = Hive.box<Practice>(_practicesBox);
    await box.put(practice.id, practice);
  }

  static Future<Practice?> getPractice(String id) async {
    final box = Hive.box<Practice>(_practicesBox);
    return box.get(id);
  }

  // User Preferences
  static Future<UserPreferences> getUserPreferences() async {
    final box = Hive.box<UserPreferences>(_userPreferencesBox);
    return box.get('preferences') ?? UserPreferences();
  }

  static Future<void> saveUserPreferences(UserPreferences preferences) async {
    final box = Hive.box<UserPreferences>(_userPreferencesBox);
    await box.put('preferences', preferences);
  }

  // Streak Data
  static Future<StreakData> getStreakData() async {
    final box = Hive.box<StreakData>(_streakDataBox);
    return box.get('streak_data') ?? StreakData();
  }

  static Future<void> saveStreakData(StreakData streakData) async {
    final box = Hive.box<StreakData>(_streakDataBox);
    await box.put('streak_data', streakData);
  }

  static Future<void> addPracticeSession() async {
    final streakData = await getStreakData();
    streakData.addPracticeSession();
    await saveStreakData(streakData);
  }

  // Reflection Prompts
  static Future<List<ReflectionPrompt>> getReflectionPrompts() async {
    final box = Hive.box<ReflectionPrompt>(_reflectionPromptsBox);
    final customPrompts = box.values.toList();
    
    // Get default prompts
    final defaultPrompts = ReflectionPrompt.getDefaultPrompts();
    
    // Combine default and custom prompts, ensuring no duplicates
    final allPrompts = <ReflectionPrompt>[];
    final seenIds = <String>{};
    
    // Add default prompts first
    for (final prompt in defaultPrompts) {
      allPrompts.add(prompt);
      seenIds.add(prompt.id);
    }
    
    // Add custom prompts that don't conflict with defaults
    for (final prompt in customPrompts) {
      if (!seenIds.contains(prompt.id)) {
        allPrompts.add(prompt);
        seenIds.add(prompt.id);
      }
    }
    
    // Sort by order
    allPrompts.sort((a, b) => a.order.compareTo(b.order));
    
    return allPrompts;
  }

  static Future<void> saveReflectionPrompt(ReflectionPrompt prompt) async {
    final box = Hive.box<ReflectionPrompt>(_reflectionPromptsBox);
    await box.put(prompt.id, prompt);
  }

  static Future<void> deleteReflectionPrompt(String id) async {
    final box = Hive.box<ReflectionPrompt>(_reflectionPromptsBox);
    await box.delete(id);
  }

  static Future<void> initializeDefaultPrompts() async {
    final box = Hive.box<ReflectionPrompt>(_reflectionPromptsBox);
    
    // Only initialize if the box is empty
    if (box.isEmpty) {
      final defaultPrompts = ReflectionPrompt.getDefaultPrompts();
      for (final prompt in defaultPrompts) {
        await box.put(prompt.id, prompt);
      }
    }
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await Hive.box<TravelLog>(_travelLogsBox).clear();
    await Hive.box<Practice>(_practicesBox).clear();
    await Hive.box<UserPreferences>(_userPreferencesBox).clear();
    await Hive.box<StreakData>(_streakDataBox).clear();
    await Hive.box<ReflectionPrompt>(_reflectionPromptsBox).clear();
  }

  static Future<void> close() async {
    try {
      // Close individual boxes with individual error handling
      await _closeBoxSafely(_travelLogsBox);
      await _closeBoxSafely(_practicesBox);
      await _closeBoxSafely(_userPreferencesBox);
      await _closeBoxSafely(_streakDataBox);
      await _closeBoxSafely(_reflectionPromptsBox);
      
      // Then close Hive completely
      await Hive.close();
    } catch (e) {
      // Ignore file system errors during cleanup
      print('Hive cleanup warning (can be ignored): $e');
    }
  }

  static Future<void> _closeBoxSafely(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.close();
      }
    } catch (e) {
      // Ignore individual box close errors (lock file issues)
      print('Box close warning for $boxName (can be ignored): $e');
    }
  }

  // Migration from SharedPreferences (if needed)
  static Future<void> migrateFromSharedPreferences() async {
    // This method can be used to migrate existing SharedPreferences data
    // Implementation would depend on the old data structure
  }
}
