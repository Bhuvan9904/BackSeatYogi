import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/services/alarm_service.dart';
import '../../widgets/common/custom_button.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _pulseController.repeat(reverse: true);
    _fadeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Time display
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCTA.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryCTA.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.self_improvement,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 80.0),
                        color: AppColors.primaryCTA,
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
              
              // Title
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      '🧘‍♀️ Time for Mindfulness',
                      style: AppTypography.headlineLarge(context).copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
              
              // Subtitle
              Text(
                'Take a moment to practice presence and awareness',
                style: AppTypography.bodyLarge(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 3),
              
              // Action buttons
              Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  children: [
                    // Stop alarm button
                    CustomButton(
                      text: '🔕 Stop Alarm',
                      icon: Icons.stop,
                      type: ButtonType.primary,
                      onPressed: _stopAlarm,
                      width: double.infinity,
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    
                    // Start practice button
                    CustomButton(
                      text: '🧘 Start Practice',
                      icon: Icons.play_arrow,
                      type: ButtonType.secondary,
                      onPressed: _startPractice,
                      width: double.infinity,
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                    
                    // Snooze button
                    CustomButton(
                      text: '⏰ Snooze (5 min)',
                      icon: Icons.snooze,
                      type: ButtonType.outline,
                      onPressed: _snoozeAlarm,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _stopAlarm() async {
    await AlarmService().stopAlarm();
    Navigator.of(context).pop();
  }

  void _startPractice() async {
    await AlarmService().stopAlarm();
    Navigator.of(context).pop();
    // Navigate to practice screen
    // You can add navigation logic here
  }

  void _snoozeAlarm() async {
    await AlarmService().stopAlarm();
    
    // Schedule alarm for 5 minutes later
    final now = DateTime.now();
    final snoozeTime = now.add(const Duration(minutes: 5));
    
    await AlarmService().scheduleDailyAlarm(
      hour: snoozeTime.hour,
      minute: snoozeTime.minute,
    );
    
    Navigator.of(context).pop();
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm snoozed for 5 minutes'),
        backgroundColor: AppColors.primaryCTA,
      ),
    );
  }
}
