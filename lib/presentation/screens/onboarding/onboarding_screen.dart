import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/services/notification_service.dart';
import '../../../providers/app_provider.dart';
import '../../navigation/app_router.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/responsive_container.dart';
import '../../widgets/common/responsive_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? selectedTravelType;
  String? selectedIntention;
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveContainer(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (currentStep + 1) / 4,
                backgroundColor: AppColors.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryCTA),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2.5),

              // Content based on current step
              Expanded(child: _buildStepContent()),

              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildTravelerTypeStep();
      case 2:
        return _buildIntentionStep();
      case 3:
        return _buildPermissionStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWelcomeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App Icon/Logo placeholder
        Container(
          width: ResponsiveUtils.getResponsiveIconSize(context, 120.0),
          height: ResponsiveUtils.getResponsiveIconSize(context, 120.0),
          decoration: BoxDecoration(
            color: AppColors.primaryCTA,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 60.0)),
          ),
          child: Icon(
            Icons.self_improvement,
            size: ResponsiveUtils.getResponsiveIconSize(context, 60.0),
            color: AppColors.textLight,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),

        ResponsiveText(
          'Welcome to Backseat Yogi',
          style: AppTypography.headlineMedium(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),

        ResponsiveText(
          'Transform your travel time into moments of mindfulness and calm',
          style: AppTypography.bodyLarge(context).copyWith(
            color: AppColors.textLight.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTravelerTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'How do you usually travel?',
          style: AppTypography.headlineMedium(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
        ResponsiveText(
          'This helps us personalize your experience',
          style: AppTypography.bodyMedium(context).copyWith(
            color: AppColors.textLight.withOpacity(0.7),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),

        Expanded(
          child: ListView.builder(
            itemCount: AppConstants.travelTypes.length,
            itemBuilder: (context, index) {
              final travelType = AppConstants.travelTypes[index];
              final isSelected = selectedTravelType == travelType;

              return CustomCard(
                margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
                onTap: () {
                  setState(() {
                    selectedTravelType = travelType;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryCTA
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getTravelIcon(travelType),
                        color: AppColors.primaryCTA,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      ),
                      SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
                      Expanded(
                        child: ResponsiveText(
                          travelType,
                          style: AppTypography.bodyLarge(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
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
        ),
      ],
    );
  }

  Widget _buildIntentionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'What would you like to focus on during your mindful travels?',
          style: AppTypography.bodyMedium(context).copyWith(
            color: AppColors.textLight.withOpacity(0.7),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),

        Expanded(
          child: ListView.builder(
            itemCount: AppConstants.intentions.length,
            itemBuilder: (context, index) {
              final intention = AppConstants.intentions[index];
              final isSelected = selectedIntention == intention;

              return CustomCard(
                margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context)),
                onTap: () {
                  setState(() {
                    selectedIntention = intention;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryCTA
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ResponsiveText(
                          intention,
                          style: AppTypography.bodyLarge(context).copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
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
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: CustomButton(
              text: 'Back',
              type: ButtonType.secondary,
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
            ),
          ),
        if (currentStep > 0) SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
        Expanded(
          child: CustomButton(
            text: currentStep == 3 ? 'Get Started' : 'Next',
            onPressed: _canProceed() ? _handleNext : null,
          ),
        ),
      ],
    );
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        return true; // Welcome step can always proceed
      case 1:
        return selectedTravelType != null;
      case 2:
        return selectedIntention != null;
      case 3:
        return true; // Permission step can always proceed
      default:
        return false;
    }
  }

  void _handleNext() async {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    } else {
      // Request notification permissions before completing onboarding
      await NotificationService.requestAllPermissions();
      
      // Save user preferences and navigate to home
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      await appProvider.setTravelerType(selectedTravelType!);
      await appProvider.setUserIntention(selectedIntention!);
      await appProvider.setFirstLaunch(false);

      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  Widget _buildPermissionStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Notification Icon
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 2),
          decoration: BoxDecoration(
            color: AppColors.primaryCTA.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context) * 2),
          ),
          child: Icon(
            Icons.notifications_active,
            size: ResponsiveUtils.getResponsiveIconSize(context, 64.0),
            color: AppColors.primaryCTA,
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
        
        // Title
        ResponsiveText(
          'Stay Mindful',
          style: AppTypography.headlineMedium(context).copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
        
        // Description
        ResponsiveText(
          'Enable notifications to receive daily mindfulness reminders',
          style: AppTypography.bodyLarge(context).copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
        
        // Benefits Card
        CustomCard(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 1.5),
            child: Column(
              children: [
                _buildBenefitItem(
                  Icons.schedule,
                  'Daily Reminders',
                  'Get notified at your chosen time each day',
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                _buildBenefitItem(
                  Icons.self_improvement,
                  'Mindful Practice',
                  'Never miss your mindfulness sessions',
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context)),
                _buildBenefitItem(
                  Icons.psychology,
                  'Better Focus',
                  'Build a consistent meditation habit',
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context) * 2),
        
        // Note
        ResponsiveText(
          'You can change this later in Settings',
          style: AppTypography.bodySmall(context).copyWith(
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context) * 0.5),
          decoration: BoxDecoration(
            color: AppColors.primaryCTA.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveCardRadius(context)),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryCTA,
            size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                title,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ResponsiveText(
                description,
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getTravelIcon(String travelType) {
    switch (travelType.toLowerCase()) {
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
}
