import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/main_layout.dart';
import '../../widgets/common/responsive_container.dart';
import '../../widgets/common/responsive_text.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../data/models/streak_data.dart';

class StreakTrackerScreen extends StatefulWidget {
  const StreakTrackerScreen({super.key});

  @override
  State<StreakTrackerScreen> createState() => _StreakTrackerScreenState();
}

class _StreakTrackerScreenState extends State<StreakTrackerScreen> {
  StreakData? streakData;
  bool isLoading = true;
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    try {
      final data = await HiveStorageService.getStreakData();
      setState(() {
        streakData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading streak data: $e');
      setState(() {
        streakData = StreakData();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2, // Streak will be accessible from Journal tab
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ResponsiveAppBar(
          title: 'Streak Tracker',
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryCTA),
              )
            : ResponsiveScrollContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStreakOverview(),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
                    _buildEnhancedCalendarView(),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
                    _buildBadgesSection(),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
                    _buildMotivationalSection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStreakOverview() {
    return CustomCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStreakStat(
                'Current Streak',
                streakData?.currentStreak ?? 0,
                'days',
                Icons.local_fire_department,
              ),
              _buildStreakStat(
                'Longest Streak',
                streakData?.longestStreak ?? 0,
                'days',
                Icons.trending_up,
              ),
              _buildStreakStat(
                'Total Sessions',
                streakData?.totalSessions ?? 0,
                '',
                Icons.self_improvement,
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
          if ((streakData?.currentStreak ?? 0) > 0) ...[
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                border: Border.all(color: AppColors.primaryCTA),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                  Expanded(
                    child: Text(
                      'You\'re on fire! ${AppConstants.streakMessages[streakData?.currentStreak ?? 0] ?? 'Keep up the great work!'}',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStreakStat(String label, int value, String unit, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryCTA,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
        Text(
          '$value',
          style: AppTypography.headlineMedium(context).copyWith(
            color: AppColors.primaryCTA,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall(context).copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (unit.isNotEmpty)
          Text(
            unit,
            style: AppTypography.bodySmall(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildEnhancedCalendarView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Practice Calendar',
              style: AppTypography.titleLarge(context).copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
                });
              },
              icon: Icon(
                Icons.chevron_left,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                color: AppColors.textLight,
              ),
            ),
            Text(
              '${_getMonthName(selectedMonth.month)} ${selectedMonth.year}',
              style: AppTypography.titleMedium(context).copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
                });
              },
              icon: Icon(
                Icons.chevron_right,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        CustomCard(
          child: Column(
            children: [
              _buildCalendarHeader(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              _buildEnhancedCalendarGrid(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              _buildCalendarLegend(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: days.map((day) {
        return Expanded(
          child: Container(
            height: ResponsiveUtils.getResponsiveSpacing(context) * 2,
            child: Center(
              child: Text(
                day,
                style: AppTypography.labelMedium(context).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnhancedCalendarGrid() {
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // Convert to 0-based (Sunday = 0)
    
    final completedDays = streakData?.completedDays ?? [];
    final currentMonthCompletedDays = completedDays
        .where((date) => date.year == selectedMonth.year && date.month == selectedMonth.month)
        .map((date) => date.day)
        .toList();

    final totalCells = firstWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Row(
          children: List.generate(7, (colIndex) {
            final cellIndex = rowIndex * 7 + colIndex;
            final dayNumber = cellIndex - firstWeekday + 1;
            
            if (cellIndex < firstWeekday || dayNumber > daysInMonth) {
              return Expanded(child: Container(height: 35));
            }

            final isCompleted = currentMonthCompletedDays.contains(dayNumber);
            final isToday = dayNumber == DateTime.now().day && 
                           selectedMonth.month == DateTime.now().month &&
                           selectedMonth.year == DateTime.now().year;
            final isPast = dayNumber < DateTime.now().day || 
                          selectedMonth.month < DateTime.now().month ||
                          selectedMonth.year < DateTime.now().year;

            return Expanded(
              child: Container(
                height: ResponsiveUtils.getResponsiveSpacing(context) * 2.5,
                margin: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.0625),
                decoration: BoxDecoration(
                  color: _getDayColor(isCompleted, isToday, isPast),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.5),
                  border: isToday
                      ? Border.all(color: AppColors.primaryCTA, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: AppTypography.labelSmall(context).copyWith(
                      color: _getDayTextColor(isCompleted, isToday, isPast),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Color _getDayColor(bool isCompleted, bool isToday, bool isPast) {
    if (isCompleted) {
      return AppColors.primaryCTA;
    } else if (isToday) {
      return AppColors.secondaryCTA;
    } else if (isPast) {
      return AppColors.secondary;
    } else {
      return AppColors.secondary.withValues(alpha: 0.3);
    }
  }

  Color _getDayTextColor(bool isCompleted, bool isToday, bool isPast) {
    if (isCompleted || isToday) {
      return AppColors.textDark;
    } else if (isPast) {
      return AppColors.textLight;
    } else {
      return AppColors.textLight.withValues(alpha: 0.5);
    }
  }

  Widget _buildCalendarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Completed', AppColors.primaryCTA),
        _buildLegendItem('Today', AppColors.secondaryCTA),
        _buildLegendItem('Past', AppColors.secondary),
        _buildLegendItem('Future', AppColors.secondary.withValues(alpha: 0.3)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
          height: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.5),
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.getResponsiveGridCrossAxisCount(context),
            childAspectRatio: 1.2,
            crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context),
            mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context),
          ),
          itemCount: AppConstants.badges.length,
          itemBuilder: (context, index) {
            final badge = AppConstants.badges.entries.elementAt(index);
            final isEarned = _isBadgeEarned(badge.key);

            return CustomCard(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  gradient: isEarned
                      ? LinearGradient(
                          colors: [
                            AppColors.primaryCTA.withValues(alpha: 0.1),
                            AppColors.primaryCTA.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                      decoration: BoxDecoration(
                        color: isEarned
                            ? AppColors.primaryCTA
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                      ),
                      child: Icon(
                        _getBadgeIcon(badge.key),
                        size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                        color: isEarned
                            ? AppColors.textLight
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    Text(
                      badge.key,
                      style: AppTypography.titleSmall(context).copyWith(
                        color: isEarned
                            ? AppColors.textLight
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                    Text(
                      badge.value,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isEarned) ...[
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
                          vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.25,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCTA,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                        ),
                        child: Text(
                          'EARNED',
                          style: AppTypography.labelSmall(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMotivationalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Motivation',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        CustomCard(
          child: Column(
            children: [
              Icon(
                Icons.psychology, 
                size: ResponsiveUtils.getResponsiveIconSize(context, 48.0), 
                color: AppColors.primaryCTA
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              Text(
                'Every mindful moment counts',
                style: AppTypography.titleMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              Text(
                'You\'re building a beautiful habit of presence and awareness. Each practice session is a step toward a more mindful life.',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  bool _isBadgeEarned(String badgeName) {
    // Real logic for badge earning based on streak data
    final sessions = streakData?.totalSessions ?? 0;
    final streak = streakData?.currentStreak ?? 0;

    switch (badgeName) {
      case 'Smooth Rider':
        return sessions >= 5;
      case 'Zen in Motion':
        return sessions >= 10;
      case 'Jet-Set Mindful':
        return sessions >= 5;
      case 'Daily Warrior':
        return streak >= 7;
      case 'Mindful Master':
        return streak >= 30;
      default:
        return false;
    }
  }

  IconData _getBadgeIcon(String badgeName) {
    switch (badgeName) {
      case 'Smooth Rider':
        return Icons.directions_car;
      case 'Zen in Motion':
        return Icons.train;
      case 'Jet-Set Mindful':
        return Icons.flight;
      case 'Daily Warrior':
        return Icons.local_fire_department;
      case 'Mindful Master':
        return Icons.self_improvement;
      default:
        return Icons.star;
    }
  }
}
