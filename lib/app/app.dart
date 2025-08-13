import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../presentation/navigation/app_router.dart';
import '../core/services/navigation_service.dart';

class BackseatYogiApp extends StatelessWidget {
  const BackseatYogiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        // Add other providers here as we create them
      ],
      child: MaterialApp(
        title: 'Backseat Yogi',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
