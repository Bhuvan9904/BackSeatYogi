import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/audio_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final VoidCallback? onComplete;
  final bool showProgress;
  final Duration? practiceDuration; // For practice sessions
  final Duration? practiceElapsed; // Current practice elapsed time
  final VoidCallback? onRestart; // Callback for practice restart
  final String? practiceName; // Name of the practice for display

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.onComplete,
    this.showProgress = true,
    this.practiceDuration,
    this.practiceElapsed,
    this.onRestart,
    this.practiceName,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      setState(() => _isLoading = true);

      // Don't re-initialize audio if it's already playing
      // Just listen to the current state
      debugPrint('AudioPlayerWidget: Listening to audio state');

      // Listen to position changes
      AudioService.positionStream.listen((position) {
        if (mounted && position != null) {
          setState(() => _position = position);
        }
      });

      // Listen to duration changes
      AudioService.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() => _duration = duration);
        }
      });

      // Listen to playing state
      AudioService.playingStream.listen((playing) {
        if (mounted) {
          debugPrint('AudioPlayerWidget: Playing state changed to: $playing');
          setState(() => _isPlaying = playing);
        }
      });

      // Set up a timer to update progress display
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted && widget.practiceDuration != null && AudioService.hasActiveTimer) {
          setState(() {
            // Trigger rebuild to update progress
          });
        }
      });

      // Listen for audio completion
      AudioService.playerStateStream.listen((state) {
        debugPrint('AudioPlayerWidget: Player state changed - ${state.processingState}');
        if (mounted && state.processingState == ProcessingState.completed) {
          // If this is a practice session and we have a practice duration,
          // don't call onComplete here as it will be handled by the practice timer
          if (widget.practiceDuration == null) {
            debugPrint('Audio completed - calling onComplete');
            widget.onComplete?.call();
          } else {
            debugPrint('Audio completed in practice mode - not calling onComplete (audio will loop)');
          }
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error initializing audio widget: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _playPause() async {
    try {
      debugPrint('_playPause called - current state: $_isPlaying');
      debugPrint('AudioService isPlaying: ${AudioService.isPlaying}');
      debugPrint('AudioService playerState: ${AudioService.playerState}');
      debugPrint('AudioService position: ${AudioService.position}');
      
      if (_isPlaying) {
        debugPrint('Pausing audio and timer...');
        await AudioService.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        debugPrint('Resuming audio and timer...');
        await AudioService.resume();
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error playing/pausing: $e');
    }
  }



  Future<void> _seekTo(Duration position) async {
    try {
      await AudioService.seekTo(position);
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  Future<void> _restart() async {
    try {
      if (widget.practiceDuration != null) {
        // For practice sessions, reset timer and restart audio
        debugPrint('Restarting practice session...');
        await AudioService.resetPracticeTimer();
        await AudioService.stop();
        await AudioService.playAudio(widget.audioUrl, practiceDuration: widget.practiceDuration);
        setState(() {
          _isPlaying = true;
        });
      } else {
        // For regular audio, restart from beginning
        debugPrint('Restarting audio from beginning...');
        await AudioService.stop();
        await AudioService.playAudio(widget.audioUrl);
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error restarting: $e');
    }
  }

  Future<void> _skipForward() async {
    try {
      if (widget.practiceDuration != null) {
        // In practice mode, advance the timer by 10 seconds
        final currentElapsed = AudioService.elapsedTime;
        final newElapsed = currentElapsed + const Duration(seconds: 10);
        
        if (newElapsed <= widget.practiceDuration!) {
          debugPrint('Practice mode: Skipping forward 10 seconds');
          // Advance the practice timer by 10 seconds
          await AudioService.advancePracticeTimer(const Duration(seconds: 10));
          
          // Also seek the audio forward to maintain sync
          final currentAudioPosition = AudioService.position ?? Duration.zero;
          final newAudioPosition = currentAudioPosition + const Duration(seconds: 10);
          final maxAudioPosition = AudioService.duration ?? Duration.zero;
          
          if (newAudioPosition <= maxAudioPosition) {
            debugPrint('Seeking audio forward to: ${_formatDuration(newAudioPosition)}');
            await AudioService.seekTo(newAudioPosition);
          } else {
            debugPrint('Audio at max position, restarting from beginning');
            await AudioService.seekTo(Duration.zero);
          }
        } else {
          debugPrint('Cannot skip forward in practice mode - would exceed practice duration');
          // Show feedback that we can't skip further
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot skip further - practice ending soon'),
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.secondaryCTA,
            ),
          );
        }
      } else {
        // Regular audio mode
        final newPosition = _position + const Duration(seconds: 10);
        final maxPosition = _duration;
        
        if (newPosition <= maxPosition) {
          debugPrint('Skipping forward 10 seconds to: ${_formatDuration(newPosition)}');
          await _seekTo(newPosition);
        } else {
          debugPrint('Cannot skip forward - already at end');
          // Show feedback that we're at the end
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Already at the end'),
              duration: const Duration(seconds: 1),
              backgroundColor: AppColors.secondaryCTA,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error skipping forward: $e');
    }
  }

  Future<void> _skipBackward() async {
    try {
      if (widget.practiceDuration != null) {
        // In practice mode, go backward in timer by 10 seconds
        final currentElapsed = AudioService.elapsedTime;
        final newElapsed = currentElapsed - const Duration(seconds: 10);
        
        if (newElapsed >= Duration.zero) {
          debugPrint('Practice mode: Skipping backward 10 seconds');
          // Go backward in practice timer by 10 seconds
          await AudioService.reversePracticeTimer(const Duration(seconds: 10));
          
          // Also seek the audio backward to maintain sync
          final currentAudioPosition = AudioService.position ?? Duration.zero;
          final newAudioPosition = currentAudioPosition - const Duration(seconds: 10);
          
          if (newAudioPosition >= Duration.zero) {
            debugPrint('Seeking audio backward to: ${_formatDuration(newAudioPosition)}');
            await AudioService.seekTo(newAudioPosition);
          } else {
            debugPrint('Audio at beginning, seeking to end');
            final maxAudioPosition = AudioService.duration ?? Duration.zero;
            await AudioService.seekTo(maxAudioPosition);
          }
        } else {
          debugPrint('Cannot skip backward in practice mode - would go below 0');
          // Show feedback that we can't go further back
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Already at the beginning of practice'),
              duration: const Duration(seconds: 1),
              backgroundColor: AppColors.secondaryCTA,
            ),
          );
        }
      } else {
        // Regular audio mode
        final newPosition = _position - const Duration(seconds: 10);
        
        if (newPosition >= Duration.zero) {
          debugPrint('Skipping backward 10 seconds to: ${_formatDuration(newPosition)}');
          await _seekTo(newPosition);
        } else {
          debugPrint('Cannot skip backward - already at beginning');
          // Show feedback that we're at the beginning
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Already at the beginning'),
              duration: const Duration(seconds: 1),
              backgroundColor: AppColors.secondaryCTA,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error skipping backward: $e');
    }
  }

  void _syncAudioState() {
    // Sync widget state with actual audio state
    final actualIsPlaying = AudioService.isPlaying;
    debugPrint('AudioPlayerWidget: _syncAudioState - actualIsPlaying: $actualIsPlaying, _isPlaying: $_isPlaying');
    if (actualIsPlaying != _isPlaying) {
      debugPrint('AudioPlayerWidget: Syncing state from $actualIsPlaying to $_isPlaying');
      setState(() => _isPlaying = actualIsPlaying);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // Sync with actual audio state
    _syncAudioState();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCTA.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Audio Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Skip Backward Button
              IconButton(
                onPressed: _isLoading ? null : _skipBackward,
                icon: Icon(
                  Icons.replay_10,
                  color: _isLoading 
                      ? AppColors.textLight.withValues(alpha: 0.3)
                      : AppColors.textLight,
                  size: 20,
                ),
                tooltip: 'Skip Backward 10s',
              ),
              const SizedBox(width: 8),

              // Play/Pause Button - Enhanced
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryCTA,
                      AppColors.primaryCTA.withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCTA.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _isLoading ? null : _playPause,
                  icon: Icon(
                    _isLoading
                        ? Icons.hourglass_empty
                        : _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: AppColors.textLight,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Skip Forward Button
              IconButton(
                onPressed: _isLoading ? null : _skipForward,
                icon: Icon(
                  Icons.forward_10,
                  color: _isLoading 
                      ? AppColors.textLight.withValues(alpha: 0.3)
                      : AppColors.textLight,
                  size: 20,
                ),
                tooltip: 'Skip Forward 10s',
              ),
            ],
          ),

          // Restart Button (moved below main controls)
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _isLoading ? null : _restart,
                icon: Icon(
                  Icons.replay,
                  color: AppColors.textLight,
                  size: 18,
                ),
                tooltip: 'Restart',
              ),
            ],
          ),

          if (widget.showProgress) ...[
            const SizedBox(height: 12),

            // Progress Bar
            Column(
              children: [
                // Progress Slider - Enhanced with better visual feedback
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primaryCTA,
                    inactiveTrackColor: AppColors.primary.withValues(alpha: 0.2),
                    thumbColor: AppColors.primaryCTA,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    trackHeight: 4,
                    overlayColor: AppColors.primaryCTA.withValues(alpha: 0.1),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    value: widget.practiceDuration != null
                        ? AudioService.elapsedTime.inMilliseconds / widget.practiceDuration!.inMilliseconds
                        : _duration.inMilliseconds > 0
                            ? _position.inMilliseconds / _duration.inMilliseconds
                            : 0.0,
                    onChanged: (value) {
                      // Always seek within the actual audio duration
                      final newPosition = Duration(
                        milliseconds: (value * _duration.inMilliseconds).round(),
                      );
                      _seekTo(newPosition);
                    },
                    onChangeStart: (value) {
                      // Visual feedback when user starts dragging
                      debugPrint('User started dragging progress bar');
                    },
                    onChangeEnd: (value) {
                      // Visual feedback when user stops dragging
                      debugPrint('User stopped dragging progress bar');
                    },
                  ),
                ),

                // Time Display - Enhanced with better styling
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.primaryCTA.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.primaryCTA,
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.practiceDuration != null
                                ? _formatDuration(AudioService.elapsedTime)
                                : _formatDuration(_position),
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.practiceDuration != null
                            ? '${widget.practiceDuration!.inMinutes}:${(widget.practiceDuration!.inSeconds % 60).toString().padLeft(2, '0')}'
                            : _formatDuration(_duration),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          
          // Audio info card - positioned at center bottom
          if (widget.practiceDuration != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryCTA.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryCTA.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCTA.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.music_note,
                      color: AppColors.primaryCTA,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.practiceName ?? 'Practice Audio',
                      style: TextStyle(
                        color: AppColors.primaryCTA,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose the audio service here as it's static
    super.dispose();
  }
}
