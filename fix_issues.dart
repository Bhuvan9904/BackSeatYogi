import 'dart:io';

void main() async {
  print('🔧 Starting automatic issue fixes...');
  
  // List of files to process
  final files = [
    'lib/presentation/screens/practice/practice_player_screen.dart',
    'lib/presentation/screens/reflection/reflection_journal_screen.dart',
    'lib/presentation/screens/onboarding/onboarding_screen.dart',
    'lib/presentation/screens/settings/settings_screen.dart',
    'lib/presentation/screens/streak/streak_tracker_screen.dart',
    'lib/presentation/screens/travel_logs/travel_logs_screen.dart',
    'lib/presentation/widgets/audio/audio_player_widget.dart',
    'lib/presentation/widgets/common/custom_button.dart',
    'lib/presentation/widgets/common/custom_card.dart',
    'lib/presentation/widgets/common/main_layout.dart',
    'lib/presentation/widgets/common/modern_card.dart',
    'lib/presentation/widgets/common/responsive_container.dart',
    'lib/core/services/audio_service.dart',
    'lib/core/services/hive_storage_service.dart',
  ];

  for (final file in files) {
    if (await File(file).exists()) {
      await processFile(file);
    }
  }
  
  print('✅ Issue fixes completed!');
}

Future<void> processFile(String filePath) async {
  print('Processing: $filePath');
  
  final file = File(filePath);
  String content = await file.readAsString();
  
  // Fix withOpacity calls
  content = content.replaceAllMapped(
    RegExp(r'\.withOpacity\(([^)]+)\)'),
    (match) => '.withValues(alpha: ${match.group(1)})',
  );
  
  // Fix print statements (but keep some for debugging)
  content = content.replaceAll('print(', 'debugPrint(');
  
  // Remove unused imports
  content = content.replaceAll(
    "import '../../widgets/common/responsive_text.dart';",
    '',
  );
  content = content.replaceAll(
    "import '../../../core/services/notification_service.dart';",
    '',
  );
  
  await file.writeAsString(content);
  print('  ✅ Fixed: $filePath');
}

