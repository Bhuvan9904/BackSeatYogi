import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/main_layout.dart';
import '../../widgets/common/responsive_container.dart';

import '../../../core/services/hive_storage_service.dart';
import '../../../data/models/travel_log.dart';
import '../../../data/models/reflection_prompt.dart';

class ReflectionJournalScreen extends StatefulWidget {
  const ReflectionJournalScreen({super.key});

  @override
  State<ReflectionJournalScreen> createState() =>
      _ReflectionJournalScreenState();
}

class _ReflectionJournalScreenState extends State<ReflectionJournalScreen> {
  final TextEditingController _thoughtsController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _customPromptController = TextEditingController();
  String? selectedMood;
  ReflectionPrompt? selectedPrompt;
  bool isSaving = false;
  List<TravelLog> reflections = [];
  bool isLoadingReflections = true;
  bool showPromptedQuestions = false;
  List<ReflectionPrompt> reflectionPrompts = [];
  bool isLoadingPrompts = true;
  bool showAddPromptDialog = false;

  // Mood emojis for better visualization
  static const Map<String, String> moodEmojis = {
    'calm': '😌',
    'distracted': '🤔',
    'focused': '🎯',
    'anxious': '😰',
    'grateful': '🙏',
    'tired': '😴',
  };

  @override
  void initState() {
    super.initState();
    _loadReflections();
    _loadReflectionPrompts();
  }

  @override
  void dispose() {
    _thoughtsController.dispose();
    _promptController.dispose();
    _customPromptController.dispose();
    super.dispose();
  }

  Future<void> _loadReflectionPrompts() async {
    try {
      final prompts = await HiveStorageService.getReflectionPrompts();
      setState(() {
        reflectionPrompts = prompts;
        isLoadingPrompts = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPrompts = false;
      });
    }
  }

  double _getMaxPromptWidth(BuildContext context) {
    final screenSize = ResponsiveUtils.getScreenSize(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return screenWidth * 0.85;
      case ScreenSize.tablet:
        return screenWidth * 0.7;
      case ScreenSize.desktop:
        return screenWidth * 0.6;
      case ScreenSize.largeDesktop:
        return screenWidth * 0.5;
    }
  }

  Future<void> _loadReflections() async {
    try {
      final logs = await HiveStorageService.getTravelLogs();
      final reflectionLogs = logs
          .where(
            (log) =>
                log.travelType == 'Mindful Practice' || log.reflection != null,
          )
          .toList();
      setState(() {
        reflections = reflectionLogs;
        isLoadingReflections = false;
      });
    } catch (e) {
      setState(() {
        isLoadingReflections = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2, // Journal is index 2
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ResponsiveAppBar(
          title: 'Reflection Journal',
        ),
        body: ResponsiveScrollContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
              _buildPromptedQuestionsSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
              _buildThoughtsSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
              _buildMoodSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
              _buildActionButtons(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
              _buildRecentEntries(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCTA.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    Icons.edit_note,
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 32.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How are you feeling?',
                        style: AppTypography.headlineMedium(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                      Text(
                        'Take a moment to reflect on your mindful journey',
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptedQuestionsSection() {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryCTA.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.secondaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guided Reflection',
                        style: AppTypography.titleLarge(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Use guided prompts to deepen your reflection',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: showPromptedQuestions,
                  onChanged: (value) {
                    setState(() {
                      showPromptedQuestions = value;
                      if (!value) {
                        selectedPrompt = null;
                        _promptController.clear();
                      }
                    });
                  },
                  activeColor: AppColors.primaryCTA,
                ),
              ],
            ),
            if (showPromptedQuestions) ...[
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    border: Border.all(
                      color: AppColors.secondaryCTA.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose a reflection prompt:',
                      style: AppTypography.titleSmall(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    Wrap(
                      spacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.4,
                      runSpacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.4,
                      children: reflectionPrompts.map((prompt) {
                        final isSelected = selectedPrompt?.id == prompt.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPrompt = isSelected ? null : prompt;
                              if (isSelected) {
                                _promptController.clear();
                              }
                              // Don't set the prompt text in the controller anymore
                              // The prompt is now displayed separately in a read-only container
                            });
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: _getMaxPromptWidth(context),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
                              vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    prompt.question,
                                    style: AppTypography.labelMedium(context).copyWith(
                                      color: isSelected
                                          ? AppColors.textLight
                                          : AppColors.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                if (prompt.category == 'custom') ...[
                                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: isSelected ? AppColors.textLight : AppColors.secondaryCTA,
                                  ),
                                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                                  GestureDetector(
                                    onTap: () => _showDeletePromptDialog(prompt),
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 12,
                                      color: isSelected ? AppColors.textLight : Colors.red,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    Row(
                      children: [
                        Expanded(
                          child: selectedPrompt != null
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                                    border: Border.all(
                                      color: AppColors.surfaceVariant,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected Prompt:',
                                        style: AppTypography.labelSmall(context).copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                                      Text(
                                        selectedPrompt!.question,
                                        style: AppTypography.bodyMedium(context).copyWith(
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : TextField(
                                  controller: _promptController,
                                  maxLines: 3,
                                  style: AppTypography.bodyMedium(context).copyWith(
                                    color: AppColors.textLight,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write your response to the selected prompt...',
                                    hintStyle: AppTypography.bodyMedium(context).copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                                      borderSide: BorderSide(color: AppColors.surfaceVariant),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                                      borderSide: BorderSide(color: AppColors.surfaceVariant),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                                      borderSide: BorderSide(color: AppColors.primaryCTA),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.surface,
                                  ),
                                ),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                        IconButton(
                          onPressed: () => _showAddPromptDialog(),
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primaryCTA,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                          ),
                          tooltip: 'Add Custom Prompt',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThoughtsSection() {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCTA.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Free Reflection',
                        style: AppTypography.titleLarge(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Express your thoughts freely',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    selectedPrompt?.question ?? 'How do you feel now?',
                    style: AppTypography.titleSmall(context).copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                if (selectedPrompt != null) ...[
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                      vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryCTA.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    ),
                    child: Text(
                      'Guided',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: AppColors.secondaryCTA,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _thoughtsController,
                maxLines: 5,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textLight,
                ),
                decoration: InputDecoration(
                  hintText: selectedPrompt != null 
                      ? 'Write your response to the selected prompt...'
                      : 'Write your thoughts here...',
                  hintStyle: AppTypography.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    borderSide: BorderSide(color: AppColors.surfaceVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    borderSide: BorderSide(color: AppColors.surfaceVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    borderSide: BorderSide(color: AppColors.primaryCTA),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSection() {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryCTA.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    Icons.sentiment_satisfied_alt,
                    color: AppColors.secondaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How would you describe your mood?',
                        style: AppTypography.titleLarge(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Select the mood that best describes how you feel',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Wrap(
              spacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
              runSpacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
              children: AppConstants.moodTags.map((mood) {
                final isSelected = selectedMood == mood;
                final emoji = moodEmojis[mood] ?? '😊';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = isSelected ? null : mood;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                      vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                        Text(
                          mood[0].toUpperCase() + mood.substring(1),
                          style: AppTypography.labelMedium(context).copyWith(
                            color: isSelected
                                ? AppColors.textLight
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: 'Save Reflection',
          icon: Icons.save,
          type: ButtonType.primary,
          onPressed: _saveReflection,
          isLoading: isSaving,
          width: double.infinity,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        CustomButton(
          text: 'Clear',
          type: ButtonType.outline,
          onPressed: _clearForm,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildRecentEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Reflections',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        if (isLoadingReflections)
          Center(
            child: CircularProgressIndicator(color: AppColors.primaryCTA),
          )
        else if (reflections.isEmpty)
          Center(
            child: CustomCard(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                      ),
                      child: Icon(
                        Icons.history,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 48.0),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    Text(
                      'No reflections yet',
                      style: AppTypography.titleLarge(context).copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                    Text(
                      'Your reflections will appear here',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reflections.take(5).length,
            itemBuilder: (context, index) {
              final reflection = reflections[index];
              return CustomCard(
                margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.self_improvement,
                          color: AppColors.primaryCTA,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                        Text(
                          reflection.formattedDate,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        if (reflection.mood != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                              vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
                            ),
                            decoration: BoxDecoration(
                              color: _getMoodColor(reflection.mood!),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  moodEmojis[reflection.mood!] ?? '😊',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                                Text(
                                  reflection.mood![0].toUpperCase() + reflection.mood!.substring(1),
                                  style: AppTypography.labelSmall(context).copyWith(
                                    color: AppColors.textLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                    Text(
                      reflection.reflection ?? '',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return Colors.blue;
      case 'focused':
        return Colors.green;
      case 'grateful':
        return Colors.orange;
      case 'anxious':
        return Colors.red;
      case 'distracted':
        return Colors.grey;
      case 'tired':
        return Colors.purple;
      default:
        return AppColors.primaryCTA;
    }
  }

  void _saveReflection() async {
    final thoughts = _thoughtsController.text.trim();
    final promptResponse = _promptController.text.trim();
    
    if (thoughts.isEmpty && promptResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your thoughts before saving'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // Combine thoughts and prompt response
      final fullReflection = [
        if (promptResponse.isNotEmpty) 'Prompt: $promptResponse',
        if (thoughts.isNotEmpty) 'Reflection: $thoughts',
      ].join('\n\n');

      // Create a travel log entry for this reflection
      final travelLog = TravelLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        destination: 'Reflection',
        travelType: 'Mindful Practice',
        reflection: fullReflection,
        mood: selectedMood,
      );

      // Save to Hive storage
      await HiveStorageService.saveTravelLog(travelLog);

      // Update streak data
      await HiveStorageService.addPracticeSession();

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reflection saved!'),
          backgroundColor: AppColors.primaryCTA,
        ),
      );

      _clearForm();
      // Reload reflections to show the new one
      await _loadReflections();
    } catch (e) {
      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving reflection: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearForm() {
    setState(() {
      _thoughtsController.clear();
      _promptController.clear();
      selectedMood = null;
      selectedPrompt = null;
      showPromptedQuestions = false;
    });
  }

  void _showAddPromptDialog() {
    _customPromptController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Custom Reflection Prompt',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create your own reflection question to help guide your mindfulness practice.',
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            TextField(
              controller: _customPromptController,
              maxLines: 3,
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.textLight,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your reflection question...',
                hintStyle: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  borderSide: BorderSide(color: AppColors.surfaceVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  borderSide: BorderSide(color: AppColors.surfaceVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  borderSide: BorderSide(color: AppColors.primaryCTA),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _addCustomPrompt(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCTA,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
            ),
            child: Text(
              'Add Prompt',
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCustomPrompt() async {
    final question = _customPromptController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reflection question'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create a new custom prompt
      final customPrompt = ReflectionPrompt(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        question: question,
        category: 'custom',
        order: reflectionPrompts.length + 1,
      );

      // Save to storage
      await HiveStorageService.saveReflectionPrompt(customPrompt);

      // Reload prompts
      await _loadReflectionPrompts();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Custom prompt added: "$question"'),
          backgroundColor: AppColors.primaryCTA,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding custom prompt: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeletePromptDialog(ReflectionPrompt prompt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Custom Prompt',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete this custom prompt?',
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                border: Border.all(
                  color: AppColors.surfaceVariant,
                  width: 1,
                ),
              ),
              child: Text(
                prompt.question,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Text(
              'This action cannot be undone.',
              style: AppTypography.bodySmall(context).copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _deleteCustomPrompt(prompt),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
            ),
            child: Text(
              'Delete',
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCustomPrompt(ReflectionPrompt prompt) async {
    try {
      // Remove from storage
      await HiveStorageService.deleteReflectionPrompt(prompt.id);

      // Clear selection if this prompt was selected
      if (selectedPrompt?.id == prompt.id) {
        setState(() {
          selectedPrompt = null;
          _promptController.clear();
        });
      }

      // Reload prompts
      await _loadReflectionPrompts();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Custom prompt deleted: "${prompt.question}"'),
          backgroundColor: AppColors.primaryCTA,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting custom prompt: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
