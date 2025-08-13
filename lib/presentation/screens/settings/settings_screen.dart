import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/main_layout.dart';
import '../../widgets/common/custom_card.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../app/theme/app_theme.dart';
import '../../../providers/app_provider.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../core/services/alarm_service.dart';
import '../alarm/alarm_screen.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/streak_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  StreakData? streakData;
  bool isLoadingStreak = true;

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
        isLoadingStreak = false;
      });
    } catch (e) {
      print('Error loading streak data: $e');
      setState(() {
        streakData = StreakData();
        isLoadingStreak = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 4, // Settings is index 4
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ResponsiveAppBar(
          title: 'Settings',
        ),
        body: SingleChildScrollView(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
              _buildProfileSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
              _buildStreakSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
              // _buildRemindersSection(), // Temporarily hidden
              // SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.25),
              _buildDataSection(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
              decoration: BoxDecoration(
                color: AppColors.primaryCTA.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
              child: Icon(
                Icons.settings,
                size: ResponsiveUtils.getResponsiveIconSize(context, 32.0),
                color: AppColors.primaryCTA,
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Settings',
                    style: AppTypography.titleLarge(context).copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  Text(
                    'Customize your mindfulness journey',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return CustomCard(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      color: AppColors.primaryCTA,
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                    Text(
                      'Profile',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _editProfile(context),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.textSecondary,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                _buildProfileInfo(
                  'Traveler Type',
                  appProvider.travelerType.isEmpty ? 'Not set' : appProvider.travelerType,
                  Icons.directions_car,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                _buildProfileInfo(
                  'Intention',
                  appProvider.userIntention.isEmpty ? 'Not set' : appProvider.userIntention,
                  Icons.psychology,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
          color: AppColors.textSecondary,
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return CustomCard(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      color: AppColors.warning,
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                    Text(
                      'Streak',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                isLoadingStreak
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryCTA),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildStreakCard(
                              'Current',
                              '${streakData?.currentStreak ?? 0} days',
                              Icons.trending_up,
                              AppColors.success,
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                          Expanded(
                            child: _buildStreakCard(
                              'Best',
                              '${streakData?.longestStreak ?? 0} days',
                              Icons.emoji_events,
                              AppColors.warning,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakCard(String title, String value, IconData icon, Color color) {
    return Container(
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
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
            color: color,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
          Text(
            title,
            style: AppTypography.bodySmall(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.titleMedium(context).copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return CustomCard(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      color: AppColors.info,
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                                          Text(
                        'Alarms',
                        style: AppTypography.titleMedium(context).copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Alarms',
                            style: AppTypography.bodyMedium(context).copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Get an alarm to practice mindfulness',
                            style: AppTypography.bodySmall(context).copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: appProvider.remindersEnabled,
                      onChanged: (value) {
                        appProvider.updateReminderSettings(enabled: value);
                      },
                      activeColor: AppColors.primaryCTA,
                    ),
                  ],
                ),
                if (appProvider.remindersEnabled) ...[
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                      border: Border.all(
                        color: AppColors.primaryCTA.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primaryCTA,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reminder Time',
                                style: AppTypography.bodySmall(context).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                appProvider.reminderTime,
                                style: AppTypography.titleMedium(context).copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCTA,
                              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 0.5),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: AppColors.textDark,
                              size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                  
                  // Test notification button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _testNotification(context),
                      icon: Icon(
                        Icons.notifications_active,
                        color: AppColors.textLight,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                      ),
                                              label: Text(
                          'Test Alarm',
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryCTA,
                        foregroundColor: AppColors.textLight,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                          vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  
                  // Reschedule notifications button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _rescheduleNotifications(context),
                      icon: Icon(
                        Icons.refresh,
                        color: AppColors.textLight,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                      ),
                                              label: Text(
                          'Reschedule Alarms',
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.info,
                        foregroundColor: AppColors.textLight,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                          vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
                  
                  // Schedule for 1 minute from now button (for testing)
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                                              onPressed: () => _testAudioOnly(context),
                      icon: Icon(
                        Icons.schedule,
                        color: AppColors.textLight,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                      ),
                                              label: Text(
                          'Test Audio Only',
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: AppColors.textLight,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context),
                          vertical: ResponsiveUtils.getResponsiveSpacing(context) * 0.75,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),

                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataSection() {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                  color: AppColors.error,
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                Text(
                  'Data & Privacy',
                  style: AppTypography.titleMedium(context).copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
            _buildDataOption(
              icon: Icons.delete_forever,
              title: 'Delete All Data',
              subtitle: 'Permanently remove all your data',
              color: AppColors.error,
              onTap: _deleteAllData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
              color: color,
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final currentTime = _parseTimeString(appProvider.reminderTime);
    
    showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryCTA,
              surface: AppColors.surface,
              onSurface: AppColors.textLight,
              onPrimary: AppColors.textDark,
              secondary: AppColors.secondaryCTA,
              onSecondary: AppColors.textDark,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.surface,
              surfaceTintColor: AppColors.primaryCTA,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surface,
              hourMinuteTextColor: AppColors.textLight,
              hourMinuteColor: AppColors.surfaceVariant,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
              dayPeriodTextColor: AppColors.textLight,
              dayPeriodColor: AppColors.surfaceVariant,
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              ),
              dialHandColor: AppColors.primaryCTA,
              dialBackgroundColor: AppColors.surfaceVariant,
              dialTextColor: AppColors.textLight,
              entryModeIconColor: AppColors.textLight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child!,
          ),
        );
      },
    ).then((picked) {
      if (picked != null) {
        final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        appProvider.updateReminderSettings(time: timeString);
      }
    });
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 8, minute: 0);
  }

  void _testNotification(BuildContext context) async {
    try {
      // Trigger test alarm with sound (vibration disabled)
      await AlarmService().testAlarm();
      
      // Show alarm screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AlarmScreen(),
        ),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test alarm triggered with sound (vibration disabled)!'),
          backgroundColor: AppColors.primaryCTA,
        ),
      );
      
      // Log debugging info
      print('Test alarm triggered successfully with sound');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error triggering test alarm: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error testing alarm: $e');
    }
  }

  void _rescheduleNotifications(BuildContext context) async {
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      // Reschedule alarms
      await appProvider.rescheduleNotifications();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alarms rescheduled successfully!'),
          backgroundColor: AppColors.primaryCTA,
        ),
      );
      
      // Log debugging info
      print('Alarms rescheduled successfully');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rescheduling alarms: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error rescheduling alarms: $e');
    }
  }

  void _testAudioOnly(BuildContext context) async {
    try {
      // Test just the audio functionality
      await AlarmService().testAudioOnly();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio test started - check console for debug info'),
          backgroundColor: AppColors.warning,
        ),
      );
      
      print('Audio test initiated');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error testing audio: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error testing audio: $e');
    }
  }

  void _scheduleTestNotification(BuildContext context) async {
    try {
      // Schedule an alarm for 1 minute from now
      final now = DateTime.now();
      final oneMinuteFromNow = now.add(const Duration(minutes: 1));
      
      await AlarmService().scheduleDailyAlarm(
        hour: oneMinuteFromNow.hour,
        minute: oneMinuteFromNow.minute,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test alarm scheduled for ${oneMinuteFromNow.hour}:${oneMinuteFromNow.minute.toString().padLeft(2, '0')}'),
          backgroundColor: AppColors.warning,
        ),
      );
      
      print('Test alarm scheduled for: ${oneMinuteFromNow.hour}:${oneMinuteFromNow.minute}');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scheduling test alarm: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error scheduling test alarm: $e');
    }
  }

  void _deleteAllData() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Delete All Data',
          style: AppTypography.titleLarge(context).copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'This action will permanently delete all your travel logs, reflections, and settings. This cannot be undone.',
          style: AppTypography.bodyMedium(context).copyWith(
            color: AppColors.textLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              HiveStorageService.clearAllData();
              Provider.of<AppProvider>(context, listen: false).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              'Delete',
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }



  void _editProfile(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Controllers for text fields
    String selectedTravelerType = appProvider.travelerType;
    String selectedIntention = appProvider.userIntention;
    
    // Predefined options - using AppConstants
    final travelerTypeOptions = AppConstants.travelTypes;
    final intentionOptions = AppConstants.intentions;
    
    // Check if current values exist in options, if not use first option
    if (selectedTravelerType.isNotEmpty && !travelerTypeOptions.contains(selectedTravelerType)) {
      selectedTravelerType = travelerTypeOptions.first;
    }
    if (selectedIntention.isNotEmpty && !intentionOptions.contains(selectedIntention)) {
      selectedIntention = intentionOptions.first;
    }
    
    // Show dialog to edit profile
    showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Edit Profile',
            style: AppTypography.titleLarge(context).copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedTravelerType.isNotEmpty ? selectedTravelerType : null,
                  decoration: InputDecoration(
                    labelText: 'Travel Mode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    ),
                    labelStyle: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: AppColors.textLight,
                  ),
                  items: travelerTypeOptions.map((String travelerType) {
                    return DropdownMenuItem<String>(
                      value: travelerType,
                      child: Text(
                        travelerType,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTravelerType = newValue ?? '';
                    });
                  },
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                DropdownButtonFormField<String>(
                  value: selectedIntention.isNotEmpty ? selectedIntention : null,
                  decoration: InputDecoration(
                    labelText: 'Intention',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                    ),
                    labelStyle: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: AppColors.textLight,
                  ),
                  items: intentionOptions.map((String intention) {
                    return DropdownMenuItem<String>(
                      value: intention,
                      child: Text(
                        intention,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIntention = newValue ?? '';
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancel',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Validate inputs
                if (selectedTravelerType.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a traveler type'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                
                if (selectedIntention.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an intention'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                
                // Update profile
                appProvider.setTravelerType(selectedTravelerType);
                appProvider.setUserIntention(selectedIntention);
                
                Navigator.pop(context, true);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: AppColors.primaryCTA,
                  ),
                );
              },
              child: Text(
                'Save',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.primaryCTA,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
