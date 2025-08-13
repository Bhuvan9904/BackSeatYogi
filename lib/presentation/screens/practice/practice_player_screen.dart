import 'package:backseat_yogi/core/services/practice_data_service_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../providers/app_provider.dart';
import '../../navigation/app_router.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/main_layout.dart';
import '../../widgets/common/responsive_container.dart';

import '../../widgets/audio/audio_player_widget.dart';
import '../../../data/models/practice.dart';

class PracticePlayerScreen extends StatefulWidget {
  const PracticePlayerScreen({super.key});

  @override
  State<PracticePlayerScreen> createState() => _PracticePlayerScreenState();
}

class _PracticePlayerScreenState extends State<PracticePlayerScreen> {
  String? selectedRideType;
  int? selectedDuration = 5; // Default to 5 minutes
  String? selectedPractice;
  bool isPlaying = false;
  bool isCompleted = false;
  double progress = 0.0;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = const Duration(minutes: 5);
  Practice? currentPractice;
  bool showPracticeText = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set default values and pre-select user's preferred travel type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      setState(() {
        // Set ride type from user preference or default to first available
        selectedRideType = appProvider.travelerType.isNotEmpty == true 
            ? appProvider.travelerType 
            : AppConstants.travelTypes.first;
        
        // Set default practice if not already set
        if (selectedPractice == null) {
          final practices = PracticeDataService.getPracticesByDuration(selectedDuration ?? 5);
          if (practices.isNotEmpty) {
            selectedPractice = practices.first.title;
            currentPractice = practices.first;
            print('Default practice set: ${practices.first.title}');
          } else {
            print('No practices found for duration: ${selectedDuration ?? 5}');
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // Stop audio when navigating away from the screen
    if (isPlaying) {
      AudioService.stop();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _syncAudioState() {
    // Sync with AudioService state when not in a practice session
    // This prevents going back to setup when audio is paused during practice
    if (currentPractice == null && !isCompleted) {
      final actualIsPlaying = AudioService.isPlaying;
      if (actualIsPlaying != isPlaying) {
        setState(() {
          isPlaying = actualIsPlaying;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    // Sync UI state with actual audio state when screen is rebuilt
    _syncAudioState();
    
    return MainLayout(
      currentIndex: 1, // Practice is index 1
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ResponsiveAppBar(
          title: 'Practice Player',
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isPlaying && !isCompleted) ...[
                // Setup Phase
                _buildSetupPhase(),
              ] else if (isPlaying) ...[
                // Playing Phase
                _buildPlayingPhase(),
              ] else if (isCompleted) ...[
                // Completion Phase
                _buildCompletionPhase(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetupPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Practice',
          style: AppTypography.headlineMedium(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),

        // Ride Type Selection
        _buildRideTypeSelection(),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),

        // Duration Selection
        _buildDurationSelection(),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),

        // Practice Type Selection
        _buildPracticeSelection(),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),

        // Debug info (remove in production)
        if (!_canStartPractice()) ...[
          CustomCard(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Info:',
                    style: AppTypography.titleMedium(context).copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  Text(
                    'Ride Type: ${selectedRideType ?? "Not selected"}',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Duration: ${selectedDuration ?? "Not selected"}',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Practice: ${selectedPractice ?? "Not selected"}',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Start Button
        CustomButton(
          text: _canStartPractice() ? 'Start Practice' : 'Please select all options',
          icon: Icons.play_arrow,
          type: ButtonType.primary,
          onPressed: _canStartPractice() ? _startPractice : null,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildRideTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ride Type',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        Row(
          children: AppConstants.travelTypes.map((type) {
            final isSelected = selectedRideType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRideType = type;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.getResponsiveSpacing(context),
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryCTA
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryCTA
                          : AppColors.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getRideIcon(type),
                        color: isSelected
                            ? AppColors.textLight
                            : AppColors.textSecondary,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8.0)),
                      Text(
                        type,
                        style: AppTypography.labelMedium(context).copyWith(
                          color: isSelected
                              ? AppColors.textLight
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Duration',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        Row(
          children: AppConstants.sessionDurations.map((duration) {
            final isSelected = selectedDuration == duration;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDuration = duration;
                    totalDuration = Duration(minutes: duration);
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.getResponsiveSpacing(context),
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryCTA
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryCTA
                          : AppColors.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$duration',
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: isSelected
                              ? AppColors.textLight
                              : AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'min',
                        style: AppTypography.labelSmall(context).copyWith(
                          color: isSelected
                              ? AppColors.textLight
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPracticeSelection() {
    final practices = PracticeDataService.getPracticesByDuration(
      selectedDuration ?? 5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Practice Type',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: practices.length,
          itemBuilder: (context, index) {
            final practice = practices[index];
            final isSelected = selectedPractice == practice.title;

            return CustomCard(
              margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
              onTap: () {
                setState(() {
                  selectedPractice = practice.title;
                  currentPractice = practice;
                });
              },
              child: Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryCTA
                        : AppColors.surfaceVariant,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getPracticeIcon(practice.title),
                      color: isSelected
                          ? AppColors.primaryCTA
                          : AppColors.textSecondary,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            practice.title,
                            style: AppTypography.titleMedium(context).copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                          Text(
                            practice.description,
                            style: AppTypography.bodySmall(context).copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryCTA,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlayingPhase() {
    if (currentPractice == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Practice Info Card - Enhanced Design
        CustomCard(
          child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryCTA.withValues(alpha: 0.1),
                  AppColors.secondaryCTA.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
            ),
            child: Column(
              children: [
                // Icon with enhanced styling
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCTA.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryCTA.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getPracticeIcon(currentPractice!.title),
                    size: ResponsiveUtils.getResponsiveIconSize(context, 48.0),
                    color: AppColors.primaryCTA,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
                
                // Title with better typography
                Text(
                  currentPractice!.title,
                  style: AppTypography.headlineSmall(context).copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
                
                // Subtitle with enhanced styling
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
                    vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryCTA.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.primaryCTA,
                        size: 16,
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                      Text(
                        '$selectedRideType • $selectedDuration minutes',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.primaryCTA,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),

        // Audio Player with enhanced styling
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCTA.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AudioPlayerWidget(
            audioUrl: currentPractice!.audioUrl,
            onComplete: _onPracticeComplete,
            onRestart: _restartPractice,
            practiceDuration: Duration(minutes: selectedDuration ?? 5),
            practiceElapsed: currentPosition,
            practiceName: currentPractice!.title,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),

        // Practice Text Toggle - Enhanced button
        Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit width to 70% of screen
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryCTA.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomButton(
              text: showPracticeText ? 'Hide Practice Text' : 'Show Practice Text',
              icon: showPracticeText ? Icons.visibility_off : Icons.visibility,
              onPressed: () {
                setState(() {
                  showPracticeText = !showPracticeText;
                });
                
                // Scroll to top when toggling practice text
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              },
              type: ButtonType.secondary,
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.25),

        // Practice Text - Enhanced card
        if (showPracticeText)
          CustomCard(
            child: Container(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceVariant,
                    AppColors.surfaceVariant.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book,
                        color: AppColors.primaryCTA,
                        size: 20,
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                      Text(
                        'Practice Guide',
                        style: AppTypography.titleMedium(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  Text(
                    currentPractice!.getPracticeText(selectedDuration ?? currentPractice!.availableDurations.first),
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textLight.withOpacity(0.9),
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompletionPhase() {
    return Column(
      children: [
        CustomCard(
          child: Column(
            children: [
              // Celebration Icon
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
                decoration: BoxDecoration(
                  color: AppColors.primaryCTA.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration, 
                  size: ResponsiveUtils.getResponsiveIconSize(context, 64.0), 
                  color: AppColors.primaryCTA
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
              Text(
                '🎉 Congratulations! 🎉',
                style: AppTypography.headlineMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              Text(
                'You\'ve successfully completed your ${selectedDuration ?? 5}-minute practice!',
                style: AppTypography.titleMedium(context).copyWith(
                  color: AppColors.primaryCTA,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              Text(
                'Great job taking time for yourself and prioritizing your well-being',
                style: AppTypography.bodyLarge(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  border: Border.all(color: AppColors.primaryCTA),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.primaryCTA,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                    Text(
                      'Take a moment to reflect on your practice',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                    Text(
                      'How do you feel now? What did you notice?',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),

        // Completion Stats Card
        CustomCard(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCompletionStat(
                  Icons.timer,
                  '${selectedDuration ?? 5} min',
                  'Practice Duration',
                  AppColors.primaryCTA,
                ),
                _buildCompletionStat(
                  Icons.self_improvement,
                  'Completed',
                  'Mindfulness',
                  AppColors.secondaryCTA,
                ),
                _buildCompletionStat(
                  Icons.favorite,
                  'Well Done!',
                  'Self Care',
                  Colors.pink,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),

        // Action Buttons
        CustomButton(
          text: '✨ Write Reflection',
          icon: Icons.edit,
          type: ButtonType.primary,
          onPressed: () => Navigator.pushNamed(context, AppRouter.reflection),
          width: double.infinity,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        CustomButton(
          text: '🔄 Start Another Practice',
          type: ButtonType.secondary,
          onPressed: _resetPractice,
          width: double.infinity,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),

      ],
    );
  }

  bool _canStartPractice() {
    final canStart = selectedRideType != null &&
        selectedDuration != null &&
        selectedPractice != null;
    
    // Debug logging
    print('=== Start Practice Debug ===');
    print('selectedRideType: $selectedRideType');
    print('selectedDuration: $selectedDuration');
    print('selectedPractice: $selectedPractice');
    print('currentPractice: $currentPractice');
    print('canStart: $canStart');
    print('========================');
    
    return canStart;
  }

  void _startPractice() {
    print('=== Starting Practice ===');
    print('_startPractice() called!');
    print('Before setState - isPlaying: $isPlaying, isCompleted: $isCompleted');
    print('Selected duration: ${selectedDuration} minutes');
    print('Current practice: ${currentPractice?.title}');
    
    if (currentPractice == null) {
      print('Error: No practice selected');
      return;
    }
    
    setState(() {
      isPlaying = true;
      progress = 0.0;
      currentPosition = Duration.zero;
    });
    
    // Scroll to top when practice starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    // Start the audio with looping for the full practice duration
    final practiceDuration = Duration(minutes: selectedDuration ?? 5);
    print('Practice duration set to: ${practiceDuration.inMinutes} minutes');
    
    // Start audio first
    AudioService.playAudio(
      currentPractice!.audioUrl, 
      practiceDuration: practiceDuration,
      onPracticeComplete: _onPracticeComplete,
    );
    
    // Force resume timer after a short delay to ensure it starts
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && isPlaying) {
        print('Force resuming timer to ensure it starts...');
        AudioService.forceResumeTimer();
      }
    });
    
    // Additional timer start attempts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && isPlaying) {
        print('Second attempt to ensure timer is running...');
        AudioService.forceResumeTimer();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && isPlaying) {
        print('Final attempt to ensure timer is running...');
        AudioService.forceResumeTimer();
      }
    });
    
    print('After setState - isPlaying: $isPlaying, isCompleted: $isCompleted');
    print('Practice duration: ${practiceDuration.inMinutes} minutes');
    print('AudioService timer status: ${AudioService.timerStatus}');
    print('AudioService has active timer: ${AudioService.hasActiveTimer}');
  }

  void _onPracticeComplete() {
    if (mounted) {
      setState(() {
        isPlaying = false;
        isCompleted = true;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _restartPractice() {
    print('_restartPractice called - restarting practice session');
    
    // Stop current audio and timer
    AudioService.stop();
    
    setState(() {
      currentPosition = Duration.zero;
      progress = 0.0;
      // Keep isPlaying true to stay in practice mode
      isPlaying = true;
      isCompleted = false;
    });
    
    // Restart the practice session
    if (currentPractice != null) {
      final practiceDuration = Duration(minutes: selectedDuration ?? 5);
      print('Restarting practice with duration: ${practiceDuration.inMinutes} minutes');
      
      AudioService.playAudio(
        currentPractice!.audioUrl, 
        practiceDuration: practiceDuration,
        onPracticeComplete: _onPracticeComplete,
      );
      
      print('Practice restart completed - AudioService.isPlaying: ${AudioService.isPlaying}');
    }
  }

  void _completePractice() {
    print('Practice completed - setting completion state');
    setState(() {
      isPlaying = false;
      isCompleted = true;
      progress = 1.0;
      currentPosition = totalDuration;
    });
    // AudioService will automatically stop the audio after the practice duration
  }

  void _resetPractice() {
    setState(() {
      isPlaying = false;
      isCompleted = false;
      progress = 0.0;
      currentPosition = Duration.zero;
    });
  }

  void _startProgressSimulation() {
    // Progress update every second for the full practice duration
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && isPlaying && !isCompleted) {
        setState(() {
          final elapsedSeconds = currentPosition.inSeconds + 1;
          final totalSeconds = totalDuration.inSeconds;
          
          if (elapsedSeconds <= totalSeconds) {
            progress = elapsedSeconds / totalSeconds;
            currentPosition = Duration(seconds: elapsedSeconds);
            
            // Log timer status every 30 seconds
            if (elapsedSeconds % 30 == 0) {
              print('Practice progress: ${elapsedSeconds}s / ${totalSeconds}s');
              print('AudioService timer status: ${AudioService.timerStatus}');
              print('AudioService has active timer: ${AudioService.hasActiveTimer}');
            }
            
            // Continue until practice duration is complete
            if (elapsedSeconds < totalSeconds) {
              _startProgressSimulation();
            } else {
              // Practice duration completed
              _completePractice();
            }
          }
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  IconData _getRideIcon(String rideType) {
    switch (rideType.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'train':
        return Icons.train;
      case 'flight':
        return Icons.flight;
      default:
        return Icons.directions_car;
    }
  }

  IconData _getPracticeIcon(String practice) {
    switch (practice) {
      case 'Mindful Breath':
        return Icons.air;
      case 'Body Scan for Travelers':
        return Icons.airline_seat_recline_normal;
      case 'Travel Gratitude':
        return Icons.favorite;
      case 'Pre-Meeting Grounding':
        return Icons.meeting_room;
      case 'Let Go of the Rush':
        return Icons.slow_motion_video;
      default:
        return Icons.self_improvement;
    }
  }

  String _getPracticeText(String practice) {
    switch (practice) {
      case 'Mindful Breath':
        return 'Find a comfortable position and close your eyes. Take a deep breath in through your nose, counting to 4. Hold for 2 counts, then exhale slowly through your mouth for 6 counts. Focus on the sensation of your breath moving in and out of your body.';
      case 'Body Scan for Travelers':
        return 'Starting from the top of your head, slowly scan down through your body. Notice any areas of tension or discomfort. As you breathe, imagine sending relaxation to each part of your body, releasing any tightness you find.';
      case 'Travel Gratitude':
        return 'Think of three things you\'re grateful for about this journey. It could be the opportunity to travel, the people you\'re with, or even the time to practice mindfulness. Allow yourself to feel this gratitude deeply.';
      case 'Pre-Meeting Grounding':
        return 'Take a moment to ground yourself before your meeting. Feel your feet on the floor, your back against the seat. Take three deep breaths, imagining roots growing from your feet into the earth, anchoring you in the present moment.';
      case 'Let Go of the Rush':
        return 'Notice any feelings of urgency or rushing. Acknowledge them without judgment, then imagine placing them in a balloon and watching them float away. Return your attention to your breath and the present moment.';
      default:
        return 'Take a moment to be present. Focus on your breath and allow yourself to be exactly where you are, without needing to be anywhere else.';
    }
  }

  Widget _buildCompletionStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.75),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
        Text(
          value,
          style: AppTypography.titleSmall(context).copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
