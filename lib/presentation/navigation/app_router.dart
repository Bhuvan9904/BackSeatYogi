import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/practice/practice_player_screen.dart';
import '../screens/reflection/reflection_journal_screen.dart';
import '../screens/travel_logs/travel_logs_screen.dart';
import '../screens/streak/streak_tracker_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_theme.dart';

class AppRouter {
  // Route names
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String practice = '/practice';
  static const String reflection = '/reflection';
  static const String travelLogs = '/travel-logs';
  static const String streak = '/streak';
  static const String settings = '/settings';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    // Handle null route name or root route
    if (routeSettings.name == null || routeSettings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          // Check if it's first launch
          final appProvider = Provider.of<AppProvider>(context, listen: false);
          
          // Wait for preferences to load before making routing decision
          return FutureBuilder(
            future: appProvider.waitForPreferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading screen while waiting
                return const Scaffold(
                  backgroundColor: AppColors.background,
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryCTA,
                    ),
                  ),
                );
              }
              
              // Now make routing decision
              if (appProvider.isFirstLaunch) {
                return const OnboardingScreen();
              } else {
                return const HomeScreen();
              }
            },
          );
        },
      );
    }

    switch (routeSettings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case practice:
        return MaterialPageRoute(builder: (_) => const PracticePlayerScreen());
      case reflection:
        return MaterialPageRoute(
          builder: (_) => const ReflectionJournalScreen(),
        );
      case travelLogs:
        return MaterialPageRoute(builder: (_) => const TravelLogsScreen());
      case streak:
        return MaterialPageRoute(builder: (_) => const StreakTrackerScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
             default:
         // For any unknown route, redirect to home if not first launch
         return MaterialPageRoute(
           builder: (context) {
             final appProvider = Provider.of<AppProvider>(context, listen: false);
             
             // Wait for preferences to load before making routing decision
             return FutureBuilder(
               future: appProvider.waitForPreferences(),
               builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                   // Show loading screen while waiting
                   return const Scaffold(
                     backgroundColor: AppColors.background,
                     body: Center(
                       child: CircularProgressIndicator(
                         color: AppColors.primaryCTA,
                       ),
                     ),
                   );
                 }
                 
                 // Now make routing decision
                 if (appProvider.isFirstLaunch) {
                   return const OnboardingScreen();
                 } else {
                   return const HomeScreen();
                 }
               },
             );
           },
         );
    }
  }
}
