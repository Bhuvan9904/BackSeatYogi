import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/services/hive_storage_service.dart';
import 'core/services/alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveStorageService.initialize();

  // Initialize Alarm Service
  await AlarmService().initialize();

  runApp(const BackseatYogiApp());
}
