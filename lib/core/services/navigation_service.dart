import 'package:flutter/material.dart';
import '../../presentation/navigation/app_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  // Navigate to a named route
  static Future<dynamic> navigateTo(String routeName) {
    return navigator!.pushNamed(routeName);
  }

  // Navigate to a named route and replace current screen
  static Future<dynamic> navigateToReplacement(String routeName) {
    return navigator!.pushReplacementNamed(routeName);
  }

  // Navigate to a named route and clear the stack
  static Future<dynamic> navigateToAndClear(String routeName) {
    return navigator!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  // Go back
  static void goBack() {
    if (navigator!.canPop()) {
      navigator!.pop();
    } else {
      // If can't pop, go to home
      navigateToReplacement(AppRouter.home);
    }
  }

  // Go back to home
  static void goHome() {
    navigateToReplacement(AppRouter.home);
  }

  // Check if can go back
  static bool canGoBack() {
    return navigator!.canPop();
  }
} 