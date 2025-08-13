import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:vibration/vibration.dart'; // Temporarily removed due to build issues
import 'audio_service.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  AudioPlayer? _audioPlayer;
  Timer? _alarmTimer;
  Timer? _vibrationTimer;
  bool _isAlarmActive = false;
  DateTime? _nextAlarmTime;
  
  // Callback for when alarm should be shown
  Function()? _onAlarmTriggered;

  // Initialize the alarm service
  Future<void> initialize() async {
    try {
      _audioPlayer = AudioPlayer();
      debugPrint('✅ Alarm service initialized successfully');
      
      // Test audio player functionality
      debugPrint('🎵 Testing audio player...');
      debugPrint('Audio player state: ${_audioPlayer!.playerState}');
      debugPrint('Audio player processing state: ${_audioPlayer!.processingState}');
      
    } catch (e) {
      debugPrint('❌ Error initializing alarm service: $e');
    }
  }

  // Set callback for when alarm triggers
  void setAlarmCallback(Function() callback) {
    _onAlarmTriggered = callback;
  }

  // Schedule daily alarm
  Future<void> scheduleDailyAlarm({
    required int hour,
    required int minute,
  }) async {
    try {
      debugPrint('=== SCHEDULING DAILY ALARM ===');
      debugPrint('Hour: $hour, Minute: $minute');
      
      // Cancel any existing alarm
      await cancelAlarm();
      
      // Calculate next alarm time
      final now = DateTime.now();
      var nextAlarm = DateTime(now.year, now.month, now.day, hour, minute);
      
      // If time has passed today, schedule for tomorrow
      if (nextAlarm.isBefore(now)) {
        nextAlarm = nextAlarm.add(const Duration(days: 1));
      }
      
      _nextAlarmTime = nextAlarm;
      
      debugPrint('Next alarm scheduled for: $nextAlarm');
      
      // Start checking for alarm time
      _startAlarmCheck();
      
    } catch (e) {
      debugPrint('Error scheduling alarm: $e');
    }
  }

  // Start checking for alarm time
  void _startAlarmCheck() {
    _alarmTimer?.cancel();
    
    _alarmTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      
      if (_nextAlarmTime != null && 
          now.hour == _nextAlarmTime!.hour && 
          now.minute == _nextAlarmTime!.minute &&
          !_isAlarmActive) {
        
        debugPrint('🎯 ALARM TIME! Triggering alarm...');
        _triggerAlarm();
        
        // Schedule next day's alarm
        _nextAlarmTime = _nextAlarmTime!.add(const Duration(days: 1));
        debugPrint('Next alarm scheduled for: $_nextAlarmTime');
      }
    });
  }

  // Trigger the alarm
  void _triggerAlarm() async {
    if (_isAlarmActive) return;
    
    _isAlarmActive = true;
    debugPrint('🔔 ALARM STARTED');
    
    try {
      // Start vibration
      _startVibration();
      
      // Start alarm sound
      await _startAlarmSound();
      
      // Notify UI to show alarm screen
      _onAlarmTriggered?.call();
      
    } catch (e) {
      debugPrint('Error triggering alarm: $e');
      _isAlarmActive = false;
    }
  }

  // Start alarm sound
  Future<void> _startAlarmSound() async {
    try {
      if (_audioPlayer != null) {
        debugPrint('🎵 Setting up alarm sound...');
        
        // Try the meditation sound first
        try {
          await _audioPlayer!.setAsset('assets/audio/386_Music/chill-lo-fi-beat-with-faint-wind-sounds-369302.mp3');
          debugPrint('✅ Audio asset set');
        } catch (assetError) {
          debugPrint('❌ Error setting audio asset: $assetError');
          // Try a different audio file as fallback
          try {
            await _audioPlayer!.setAsset('assets/audio/386_Music/morning-garden-acoustic-chill-15013.mp3');
            debugPrint('✅ Fallback audio asset set');
          } catch (fallbackError) {
            debugPrint('❌ Error setting fallback audio: $fallbackError');
            return; // Give up if both fail
          }
        }
        
        await _audioPlayer!.setLoopMode(LoopMode.all);
        debugPrint('✅ Loop mode set');
        
        await _audioPlayer!.setVolume(0.8);
        debugPrint('✅ Volume set to 0.8');
        
        await _audioPlayer!.play();
        debugPrint('🔊 Alarm sound started successfully');
        
        // Listen for player state changes
        _audioPlayer!.playerStateStream.listen((state) {
          debugPrint('🎵 Player state: ${state.processingState} - ${state.playing}');
        });
        
      } else {
        debugPrint('❌ Audio player is null!');
      }
    } catch (e) {
      debugPrint('❌ Error playing alarm sound: $e');
      // Fallback: use system beep or vibration only
    }
  }

  // Start vibration pattern (disabled due to build issues)
  void _startVibration() {
    _vibrationTimer?.cancel();
    
    // Vibration temporarily disabled due to build compatibility issues
    debugPrint('📳 Vibration disabled - audio alarm only');
    
    // Simple timer for future vibration implementation
    _vibrationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isAlarmActive) {
        debugPrint('📳 Vibration would trigger here (disabled)');
      } else {
        timer.cancel();
      }
    });
  }

  // Stop the alarm
  Future<void> stopAlarm() async {
    debugPrint('🔕 ALARM STOPPED');
    
    _isAlarmActive = false;
    
    // Stop sound
    await _audioPlayer?.stop();
    
    // Stop vibration
    _vibrationTimer?.cancel();
    // Vibration.cancel() removed due to build issues
    debugPrint('📳 Vibration stopped');
  }

  // Cancel scheduled alarm
  Future<void> cancelAlarm() async {
    debugPrint('❌ ALARM CANCELLED');
    
    await stopAlarm();
    _alarmTimer?.cancel();
    _nextAlarmTime = null;
  }

  // Check if alarm is active
  bool get isAlarmActive => _isAlarmActive;

  // Get next alarm time
  DateTime? get nextAlarmTime => _nextAlarmTime;

  // Test alarm (for immediate testing)
  Future<void> testAlarm() async {
    try {
      debugPrint('🧪 TESTING ALARM');
      
      // Stop any existing alarm first
      await stopAlarm();
      
      // Check if practice audio is playing and pause it temporarily
      final practicePlayer = AudioService.player;
      bool wasPracticePlaying = false;
      if (practicePlayer.playing) {
        debugPrint('⏸️ Pausing practice audio for alarm test');
        await practicePlayer.pause();
        wasPracticePlaying = true;
      }
      
      // Set alarm as active
      _isAlarmActive = true;
      
      // Start vibration
      _startVibration();
      
      // Start alarm sound
      await _startAlarmSound();
      
      debugPrint('✅ Test alarm started successfully');
      
      // If practice was playing, resume it after a short delay
      if (wasPracticePlaying) {
        Future.delayed(const Duration(seconds: 5), () async {
          if (!_isAlarmActive) {
            debugPrint('▶️ Resuming practice audio');
            await practicePlayer.play();
          }
        });
      }
      
    } catch (e) {
      debugPrint('❌ Error testing alarm: $e');
      _isAlarmActive = false;
    }
  }

  // Simple audio test (for debugging)
  Future<void> testAudioOnly() async {
    try {
      debugPrint('🎵 TESTING AUDIO ONLY');
      
      if (_audioPlayer != null) {
        await _audioPlayer!.setAsset('assets/audio/386_Music/chill-lo-fi-beat-with-faint-wind-sounds-369302.mp3');
        await _audioPlayer!.setVolume(1.0);
        await _audioPlayer!.play();
        
        debugPrint('✅ Audio test started');
        
        // Stop after 3 seconds
        Future.delayed(const Duration(seconds: 3), () async {
          await _audioPlayer!.stop();
          debugPrint('✅ Audio test completed');
        });
      }
    } catch (e) {
      debugPrint('❌ Audio test failed: $e');
    }
  }

  // Dispose resources
  Future<void> dispose() async {
    await cancelAlarm();
    await _audioPlayer?.dispose();
  }
}
