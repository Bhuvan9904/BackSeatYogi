import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../data/models/streak_data.dart';
import '../../navigation/app_router.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/main_layout.dart';
import '../../widgets/common/responsive_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreakData? streakData;
  bool isLoading = true;
  Timer? _greetingTimer;

  @override
  void initState() {
    super.initState();
    _loadStreakData();
    _startGreetingTimer();
  }

  @override
  void dispose() {
    _greetingTimer?.cancel();
    super.dispose();
  }

  void _startGreetingTimer() {
    // Update greeting every minute
    _greetingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          // This will trigger a rebuild with the new greeting
        });
      }
    });
  }

  String _getTimeBasedGreeting() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else if (hour >= 21 && hour < 24) {
      return 'Good Night';
    } else {
      return 'Good Night'; // 12 AM to 5 AM
    }
  }

  IconData _getTimeBasedIcon() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny; // Morning sun
    } else if (hour >= 12 && hour < 17) {
      return Icons.wb_sunny_outlined; // Afternoon sun
    } else if (hour >= 17 && hour < 21) {
      return Icons.nights_stay; // Evening moon
    } else if (hour >= 21 && hour < 24) {
      return Icons.nightlight; // Night moon
    } else {
      return Icons.nightlight; // Late night moon
    }
  }

  String _getTimeBasedMessage() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 5 && hour < 12) {
      return 'Ready for your mindful journey?';
    } else if (hour >= 12 && hour < 17) {
      return 'Take a moment to center yourself';
    } else if (hour >= 17 && hour < 21) {
      return 'Time to unwind and reflect';
    } else if (hour >= 21 && hour < 24) {
      return 'Prepare for peaceful rest';
    } else {
      return 'Time for quiet contemplation';
    }
  }

  Future<void> _loadStreakData() async {
    try {
      final data = await HiveStorageService.getStreakData();
      setState(() {
        streakData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading streak data: $e');
      setState(() {
        streakData = StreakData();
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning to home screen
    if (!isLoading) {
      _loadStreakData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ResponsiveAppBar(
          title: 'Backseat Yogi',
        ),
        body: ResponsiveScrollContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),

              // Start Practice Button - Centered
              Center(
                child: _buildStartPracticeButton(),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),

              // Progress Section
              _buildProgressSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),

              // Quick Actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
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
                    color: AppColors.primaryCTA.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Icon(
                    _getTimeBasedIcon(),
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getTimeBasedGreeting(),
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
                      Text(
                        _getTimeBasedMessage(),
                        style: AppTypography.bodyMedium(context).copyWith(
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

  Widget _buildStartPracticeButton() {
    return CustomCard(
      onTap: () => Navigator.pushNamed(context, AppRouter.practice),
      child: Container(
        height: ResponsiveUtils.getResponsiveButtonHeight(context) * 4, // Responsive height
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              decoration: BoxDecoration(
                color: AppColors.primaryCTA.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
              child: Icon(
                Icons.self_improvement,
                color: AppColors.primaryCTA,
                size: ResponsiveUtils.getResponsiveIconSize(context, 48.0),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Flexible(
              child: Text(
                'Start Mindful Ride',
                style: AppTypography.headlineSmall(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
            Flexible(
              child: Text(
                'Begin your journey to mindfulness',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    if (isLoading) {
      return CustomCard(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: AppColors.primaryCTA,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  Text(
                    'Your Progress',
                    style: AppTypography.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              const Center(
                child: CircularProgressIndicator(color: AppColors.primaryCTA),
              ),
            ],
          ),
        ),
      );
    }

    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppColors.primaryCTA,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                Text(
                  'Your Progress',
                  style: AppTypography.titleMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Row(
              children: [
                Expanded(
                  child: _buildProgressCard(
                    'Current Streak',
                    '${streakData?.currentStreak ?? 0}',
                    'days',
                    Icons.local_fire_department,
                    AppColors.primaryCTA,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Expanded(
                  child: _buildProgressCard(
                    'Total Sessions',
                    '${streakData?.totalSessions ?? 0}',
                    '',
                    Icons.self_improvement,
                    AppColors.secondaryCTA,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String label, String value, String unit, IconData icon, Color color) {
    return Container(
      height: 160, // Increased height for better visual prominence
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
          Flexible(
            child: Text(
              value,
              style: AppTypography.headlineMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (unit.isNotEmpty)
            Flexible(
              child: Text(
                unit,
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.headlineSmall(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
          mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context) * 0.5,
          children: [
            _buildQuickActionCard(
              'Journal',
              Icons.book,
              AppColors.primaryCTA,
              () => Navigator.pushNamed(context, AppRouter.reflection),
            ),
            _buildQuickActionCard(
              'Logs',
              Icons.history,
              AppColors.secondaryCTA,
              () => Navigator.pushNamed(context, AppRouter.travelLogs),
            ),
            _buildQuickActionCard(
              'Streak',
              Icons.trending_up,
              AppColors.primaryCTA,
              () => Navigator.pushNamed(context, AppRouter.streak),
            ),
            _buildQuickActionCard(
              'Settings',
              Icons.settings,
              AppColors.secondaryCTA,
              () => Navigator.pushNamed(context, AppRouter.settings),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            Flexible(
              child: Text(
                title,
                style: AppTypography.titleMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }


}

