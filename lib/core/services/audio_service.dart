import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isInitialized = false;
  static Timer? _practiceTimer;
  static VoidCallback? _onPracticeComplete;
  static Duration _remainingTime = Duration.zero;
  static Duration _totalDuration = Duration.zero;
  static bool _isTimerPaused = false;
  static bool _isPracticeCompleted = false;

  static AudioPlayer get player => _audioPlayer;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      _isInitialized = true;
    }
  }

  static Future<void> playAudio(String audioUrl, {Duration? practiceDuration, VoidCallback? onPracticeComplete}) async {
    try {
      debugPrint('=== Starting Audio Playback ===');
      debugPrint('Audio URL: $audioUrl');
      debugPrint('Practice duration: ${practiceDuration?.inMinutes} minutes');
      
      // Cancel any existing timer
      if (_practiceTimer != null) {
        debugPrint('Cancelling existing practice timer');
        _practiceTimer!.cancel();
        _practiceTimer = null;
      }
      
      await initialize();
      await _audioPlayer.setAsset(audioUrl);
      
      // Set volume to maximum
      await _audioPlayer.setVolume(1.0);
      
      // Set loop mode to all for continuous playback
      await _audioPlayer.setLoopMode(LoopMode.all);
      
      // Start playing
      await _audioPlayer.play();
      
      debugPrint('Audio started: $audioUrl');
      debugPrint('Volume set to: ${_audioPlayer.volume}');
      debugPrint('Is playing: ${_audioPlayer.playing}');
      debugPrint('Audio duration: ${_audioPlayer.duration}');
      debugPrint('Loop mode: ${_audioPlayer.loopMode}');
      debugPrint('=== Audio Playback Started ===');
      
      // Store the callback
      _onPracticeComplete = onPracticeComplete;
      
      // Timer to stop after practice duration
      if (practiceDuration != null) {
        debugPrint('Setting practice timer for ${practiceDuration.inMinutes} minutes (${practiceDuration.inSeconds} seconds)');
        _totalDuration = practiceDuration;
        _remainingTime = practiceDuration;
        _isTimerPaused = false;
        _isPracticeCompleted = false; // Reset completion flag
        debugPrint('Timer state before starting: paused=$_isTimerPaused, remaining=${_remainingTime.inSeconds}');
        
        // Force reset timer state and ensure it's not paused
        _isTimerPaused = false;
        
        // Start timer immediately without delay
        _startPracticeTimer();
        debugPrint('Timer state after starting: paused=$_isTimerPaused, remaining=${_remainingTime.inSeconds}');
        
        // Verify timer is running after a short delay
        await Future.delayed(const Duration(milliseconds: 200));
        debugPrint('Timer state after 200ms: paused=$_isTimerPaused, remaining=${_remainingTime.inSeconds}, hasTimer=${_practiceTimer != null}');
        
        // Ensure timer is running
        if (_practiceTimer == null) {
          debugPrint('WARNING: Timer not created, trying again...');
          _startPracticeTimer();
        }
        
        // Final verification
        await Future.delayed(const Duration(milliseconds: 300));
        debugPrint('Final timer state: paused=$_isTimerPaused, remaining=${_remainingTime.inSeconds}, hasTimer=${_practiceTimer != null}');
      } else {
        debugPrint('No practice duration specified - audio will play indefinitely');
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      rethrow;
    }
  }

  static Future<void> pause() async {
    try {
      debugPrint('=== PAUSE CALLED ===');
      debugPrint('Pausing audio and timer...');
      debugPrint('Audio position before pause: ${_audioPlayer.position}');
      debugPrint('Audio duration: ${_audioPlayer.duration}');
      debugPrint('Audio loop mode: ${_audioPlayer.loopMode}');
      
      await _audioPlayer.pause();
      _pausePracticeTimer();
      
      debugPrint('Audio position after pause: ${_audioPlayer.position}');
      debugPrint('=== PAUSE COMPLETED ===');
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  static Future<void> resume() async {
    try {
      debugPrint('Resuming audio and timer...');
      debugPrint('Audio position before resume: ${_audioPlayer.position}');
      debugPrint('Audio duration: ${_audioPlayer.duration}');
      debugPrint('Audio loop mode: ${_audioPlayer.loopMode}');
      
      // Ensure the audio is still in loop mode
      if (_audioPlayer.loopMode != LoopMode.all) {
        debugPrint('Resetting loop mode to LoopMode.all');
        await _audioPlayer.setLoopMode(LoopMode.all);
      }
      
      await _audioPlayer.play();
      _resumePracticeTimer();
      
      // If timer is not running, start it
      if (_practiceTimer == null && _totalDuration.inSeconds > 0) {
        debugPrint('Timer not running, starting it now...');
        _startPracticeTimer();
      }
      
      debugPrint('Audio position after resume: ${_audioPlayer.position}');
      debugPrint('Audio is playing: ${_audioPlayer.playing}');
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  static Future<void> stop() async {
    try {
      // Cancel the practice timer if it exists
      _practiceTimer?.cancel();
      _practiceTimer = null;
      
      // Clear the callback and reset completion state
      _onPracticeComplete = null;
      _isPracticeCompleted = false;
      
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  static Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking audio: $e');
    }
  }

  static Future<void> advancePracticeTimer(Duration advanceBy) async {
    try {
      if (_practiceTimer != null) {
        debugPrint('Advancing practice timer by ${advanceBy.inSeconds} seconds');
        final newRemaining = _remainingTime - advanceBy;
        
        if (newRemaining >= Duration.zero) {
          _remainingTime = newRemaining;
          debugPrint('Practice timer advanced. New remaining time: ${_remainingTime.inSeconds} seconds');
        } else {
          debugPrint('Cannot advance timer - would exceed practice duration');
        }
      } else {
        debugPrint('Cannot advance timer - timer not active');
      }
    } catch (e) {
      debugPrint('Error advancing practice timer: $e');
    }
  }

  static Future<void> reversePracticeTimer(Duration reverseBy) async {
    try {
      if (_practiceTimer != null) {
        debugPrint('Reversing practice timer by ${reverseBy.inSeconds} seconds');
        final newRemaining = _remainingTime + reverseBy;
        
        if (newRemaining <= _totalDuration) {
          _remainingTime = newRemaining;
          debugPrint('Practice timer reversed. New remaining time: ${_remainingTime.inSeconds} seconds');
        } else {
          debugPrint('Cannot reverse timer - would exceed total duration');
        }
      } else {
        debugPrint('Cannot reverse timer - timer not active');
      }
    } catch (e) {
      debugPrint('Error reversing practice timer: $e');
    }
  }

  static Future<void> resetPracticeTimer() async {
    try {
      if (_practiceTimer != null) {
        debugPrint('Resetting practice timer to beginning');
        _remainingTime = _totalDuration;
        debugPrint('Practice timer reset. Remaining time: ${_remainingTime.inSeconds} seconds');
      } else {
        debugPrint('Cannot reset timer - no active timer');
      }
    } catch (e) {
      debugPrint('Error resetting practice timer: $e');
    }
  }

  // Force start timer for debugging
  static Future<void> forceStartTimer(Duration duration) async {
    try {
      debugPrint('=== FORCE STARTING TIMER ===');
      
      // Cancel any existing timer
      _practiceTimer?.cancel();
      _practiceTimer = null;
      
      // Set up timer
      _totalDuration = duration;
      _remainingTime = duration;
      _isTimerPaused = false;
      
      debugPrint('Timer setup - total: ${_totalDuration.inSeconds}s, remaining: ${_remainingTime.inSeconds}s, paused: $_isTimerPaused');
      
      _startPracticeTimer();
      
      debugPrint('=== FORCE TIMER STARTED ===');
    } catch (e) {
      debugPrint('Error force starting timer: $e');
    }
  }

  // Force resume timer if it's paused
  static Future<void> forceResumeTimer() async {
    try {
      debugPrint('=== FORCE RESUMING TIMER ===');
      debugPrint('Current timer state - paused: $_isTimerPaused, hasTimer: ${_practiceTimer != null}');
      
      if (_practiceTimer == null && _totalDuration.inSeconds > 0) {
        debugPrint('No timer running, starting new timer...');
        _startPracticeTimer();
      } else if (_isTimerPaused) {
        debugPrint('Timer is paused, resuming...');
        _isTimerPaused = false;
      } else {
        debugPrint('Timer is already running');
      }
      
      // Force ensure timer is not paused
      _isTimerPaused = false;
      debugPrint('Timer paused state forced to: $_isTimerPaused');
      
      debugPrint('=== FORCE TIMER RESUME COMPLETE ===');
    } catch (e) {
      debugPrint('Error force resuming timer: $e');
    }
  }

  static Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
      debugPrint('Volume set to: $volume');
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  static double get volume => _audioPlayer.volume;
  
  static Future<void> testAudio() async {
    try {
      debugPrint('=== Testing Audio ===');
      debugPrint('Current volume: ${_audioPlayer.volume}');
      debugPrint('Is playing: ${_audioPlayer.playing}');
      debugPrint('Audio duration: ${_audioPlayer.duration}');
      debugPrint('Player state: ${_audioPlayer.playerState}');
      debugPrint('Loop mode: ${_audioPlayer.loopMode}');
      debugPrint('=== Audio Test Complete ===');
    } catch (e) {
      debugPrint('Error testing audio: $e');
    }
  }

  static Future<void> ensureLooping() async {
    try {
      if (!_audioPlayer.playing) {
        debugPrint('Audio stopped - restarting to maintain loop');
        await _audioPlayer.play();
      }
      
      if (_audioPlayer.loopMode != LoopMode.all) {
        debugPrint('Loop mode reset - setting to LoopMode.all');
        await _audioPlayer.setLoopMode(LoopMode.all);
      }
    } catch (e) {
      debugPrint('Error ensuring looping: $e');
    }
  }

  static Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  static Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  static Stream<PlayerState> get playerStateStream =>
      _audioPlayer.playerStateStream;
  static Stream<bool> get playingStream => _audioPlayer.playingStream;

  static Duration? get position => _audioPlayer.position;
  static Duration? get duration => _audioPlayer.duration;
  static PlayerState get playerState => _audioPlayer.playerState;
  static bool get isPlaying => _audioPlayer.playing;

  static bool get hasActiveTimer => _practiceTimer != null;
  static bool get isPracticeCompleted => _isPracticeCompleted;
  
  static String get timerStatus {
    if (_practiceTimer == null) {
      return 'No active timer';
    } else {
      return 'Timer is active (paused: $_isTimerPaused)';
    }
  }
  
  static Duration get remainingTime => _remainingTime;
  static Duration get elapsedTime => _totalDuration - _remainingTime;
  static bool get isTimerPaused => _isTimerPaused;
  
  static void debugTimerState() {
    debugPrint('=== Timer Debug State ===');
    debugPrint('Total duration: ${_totalDuration.inSeconds} seconds');
    debugPrint('Remaining time: ${_remainingTime.inSeconds} seconds');
    debugPrint('Elapsed time: ${(_totalDuration - _remainingTime).inSeconds} seconds');
    debugPrint('Is timer paused: $_isTimerPaused');
    debugPrint('Has active timer: ${_practiceTimer != null}');
    debugPrint('Timer status: $timerStatus');
    debugPrint('========================');
  }

  // Test method to manually start a timer for debugging
  static void testTimer(Duration duration) {
    debugPrint('=== Testing Timer ===');
    debugPrint('Setting up test timer for ${duration.inSeconds} seconds');
    
    // Cancel any existing timer
    _practiceTimer?.cancel();
    _practiceTimer = null;
    
    // Set up test timer
    _totalDuration = duration;
    _remainingTime = duration;
    _isTimerPaused = false;
    
    _startPracticeTimer();
    
    debugPrint('Test timer started');
    debugTimerState();
  }

  static Future<void> dispose() async {
    try {
      _practiceTimer?.cancel();
      _practiceTimer = null;
      _onPracticeComplete = null;
      await _audioPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    }
  }

    // Private timer management methods
  static void _startPracticeTimer() {
    debugPrint('=== STARTING PRACTICE TIMER ===');
    debugPrint('Starting practice timer with ${_remainingTime.inSeconds} seconds remaining');
    debugPrint('Total duration: ${_totalDuration.inSeconds} seconds');
    debugPrint('Current timer state - paused: $_isTimerPaused, hasActiveTimer: ${_practiceTimer != null}');
    
    // Cancel any existing timer first
    if (_practiceTimer != null) {
      debugPrint('Cancelling existing timer before starting new one');
      _practiceTimer!.cancel();
      _practiceTimer = null;
    }
    
    // Reset timer state and ensure it's not paused
    _isTimerPaused = false;
    debugPrint('Timer paused state set to: $_isTimerPaused');
    
    // Start timer immediately
    _practiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint('Timer tick - paused: $_isTimerPaused, remaining: ${_remainingTime.inSeconds}');
      
      // Only count down if timer is not paused
      if (!_isTimerPaused) {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          debugPrint('Practice timer: ${_remainingTime.inSeconds} seconds remaining, elapsed: ${_totalDuration.inSeconds - _remainingTime.inSeconds} seconds');
        } else {
          debugPrint('=== Practice Timer Completed ===');
          debugPrint('Practice duration completed, stopping audio');
          timer.cancel();
          _practiceTimer = null;
          _isPracticeCompleted = true;
          
          // Stop audio and prevent looping
          _audioPlayer.stop();
          
          // Call the completion callback
          if (_onPracticeComplete != null) {
            debugPrint('Calling practice completion callback');
            _onPracticeComplete!.call();
            _onPracticeComplete = null;
          } else {
            debugPrint('No practice completion callback found');
          }
          debugPrint('=== Practice Timer Cleanup Complete ===');
        }
      } else {
        debugPrint('Timer tick - PAUSED, remaining: ${_remainingTime.inSeconds}');
        // Auto-resume if timer is paused for too long
        if (_remainingTime == _totalDuration) {
          debugPrint('Auto-resuming timer that was paused at start');
          _isTimerPaused = false;
        }
      }
    });
    
    if (_practiceTimer != null) {
      debugPrint('Practice timer created successfully');
      debugPrint('=== PRACTICE TIMER STARTED ===');
    } else {
      debugPrint('ERROR: Practice timer was not created!');
    }
  }

  static void _pausePracticeTimer() {
    debugPrint('=== PAUSING PRACTICE TIMER ===');
    debugPrint('Pausing practice timer');
    debugPrint('Current timer state - remaining: ${_remainingTime.inSeconds}, paused: $_isTimerPaused');
    
    // Allow pausing in all cases - remove restrictive logic
    _isTimerPaused = true;
    debugPrint('Timer paused state set to: $_isTimerPaused');
    debugPrint('=== PRACTICE TIMER PAUSED ===');
  }

  static void _resumePracticeTimer() {
    debugPrint('=== RESUMING PRACTICE TIMER ===');
    debugPrint('Resuming practice timer');
    debugPrint('Current timer state - remaining: ${_remainingTime.inSeconds}, paused: $_isTimerPaused');
    _isTimerPaused = false;
    debugPrint('Timer paused state set to: $_isTimerPaused');
    debugPrint('=== PRACTICE TIMER RESUMED ===');
  }
}
