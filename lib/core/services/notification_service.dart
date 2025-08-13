import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Combined initialization settings
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialize the plugin
      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      // Request permissions immediately
      await _requestPermissions();

    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
    }
  }

  static Future<void> _createNotificationChannel() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'backseat_yogi_channel',
        'Backseat Yogi Notifications',
        description: 'Notifications for mindfulness sessions and daily reminders',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(channel);
      }
    } catch (e) {
      debugPrint('Failed to create notification channel: $e');
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      // Check if Android implementation is available
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
      
      // Check if iOS implementation is available
      final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      
      if (iosImplementation != null) {
        await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('Failed to request notification permissions: $e');
    }
  }

  static Future<bool> requestAllPermissions() async {
    try {
      debugPrint('Requesting all notification permissions...');
      
      // Request basic notification permissions
      await _requestPermissions();
      
      // Wait a moment for permissions to be processed
      await Future.delayed(const Duration(seconds: 1));
      
      // Check if notifications are enabled
      final notificationsEnabled = await areNotificationsEnabled();
      
      if (!notificationsEnabled) {
        debugPrint('Notification permissions not granted');
        return false;
      }
      
      debugPrint('All notification permissions granted successfully');
      return true;
    } catch (e) {
      debugPrint('Error requesting all permissions: $e');
      return false;
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
    
    // If it's a daily reminder, reschedule the next one
    if (response.payload == 'daily_reminder') {
      debugPrint('Daily reminder tapped, will reschedule for tomorrow');
      // The notification will be automatically rescheduled by the system
      // due to matchDateTimeComponents: DateTimeComponents.time
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'backseat_yogi_channel',
        'Backseat Yogi Notifications',
        channelDescription: 'Notifications for mindfulness sessions',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _notifications.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Failed to show notification: $e');
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'backseat_yogi_channel',
        'Backseat Yogi Notifications',
        channelDescription: 'Notifications for mindfulness sessions',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFF3CC45B),
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        categoryIdentifier: 'reminder',
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // Convert to timezone-aware datetime
      final scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);
      
      debugPrint('Scheduling notification for: $scheduledTZ');
      debugPrint('Current time: ${tz.TZDateTime.now(tz.local)}');

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTZ,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      
      debugPrint('Notification scheduled successfully for ID: $id');
    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
    }
  }

  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    try {
      debugPrint('=== SCHEDULING DAILY NOTIFICATION ===');
      debugPrint('ID: $id, Hour: $hour, Minute: $minute');
      
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'backseat_yogi_channel',
        'Backseat Yogi Notifications',
        channelDescription: 'Notifications for mindfulness sessions',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFF3CC45B),
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        categoryIdentifier: 'reminder',
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // Create a timezone-aware datetime for the specified time today
      final now = tz.TZDateTime.now(tz.local);
      var scheduledTZ = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      
      // If the time has passed today, schedule for tomorrow
      if (scheduledTZ.isBefore(now)) {
        scheduledTZ = scheduledTZ.add(const Duration(days: 1));
        debugPrint('Time has passed today, scheduling for tomorrow: $scheduledTZ');
      }
      
      debugPrint('Scheduling daily notification for: $scheduledTZ');
      debugPrint('Current time: ${tz.TZDateTime.now(tz.local)}');

      // Cancel any existing notification with this ID first
      await _notifications.cancel(id);
      debugPrint('Cancelled existing notification with ID: $id');

      try {
        // Method 1: Try with exact alarm and daily repetition
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledTZ,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        
        debugPrint('✅ Daily notification scheduled successfully with exact alarm for ID: $id');
        
        // Verify the notification was scheduled
        final pendingNotifications = await _notifications.pendingNotificationRequests();
        final scheduledNotification = pendingNotifications.where((n) => n.id == id).firstOrNull;
        if (scheduledNotification != null) {
          debugPrint('✅ Verified: Notification ID $id is in pending notifications');
        } else {
          debugPrint('❌ Warning: Notification ID $id not found in pending notifications');
        }
        
      } catch (e) {
        debugPrint('❌ Exact alarm failed, trying method 2: $e');
        
        try {
          // Method 2: Schedule without exact alarm
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            scheduledTZ,
            platformChannelSpecifics,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          
          debugPrint('✅ Daily notification scheduled successfully with method 2 for ID: $id');
        } catch (e2) {
          debugPrint('❌ Method 2 failed, trying method 3: $e2');
          
          try {
            // Method 3: Schedule for next 7 days manually
            for (int day = 0; day < 7; day++) {
              final futureDate = scheduledTZ.add(Duration(days: day));
              await _notifications.zonedSchedule(
                id + day, // Different ID for each day
                title,
                body,
                futureDate,
                platformChannelSpecifics,
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                payload: payload,
              );
            }
            
            debugPrint('✅ Scheduled notifications for next 7 days (IDs: $id to ${id + 6})');
          } catch (e3) {
            debugPrint('❌ All scheduling methods failed: $e3');
            
            // Final fallback: immediate notification
            await _notifications.show(
              id,
              title,
              body,
              platformChannelSpecifics,
              payload: payload,
            );
            
            debugPrint('⚠️ Sent immediate notification as final fallback for ID: $id');
          }
        }
      }
      
      // Final verification
      final finalPendingNotifications = await _notifications.pendingNotificationRequests();
      debugPrint('📊 Total pending notifications: ${finalPendingNotifications.length}');
      for (var notification in finalPendingNotifications) {
        debugPrint('📋 Pending notification ID: ${notification.id}, Title: ${notification.title}');
      }
      
    } catch (e) {
      debugPrint('❌ Fatal error in scheduleDailyNotification: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      debugPrint('Failed to cancel notification: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      debugPrint('Failed to cancel all notifications: $e');
    }
  }

  static Future<bool> areNotificationsEnabled() async {
    try {
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        return await androidImplementation.areNotificationsEnabled() ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to check notification permissions: $e');
      return false;
    }
  }



  static Future<void> testNotification() async {
    try {
      await showNotification(
        id: 999,
        title: '🧘‍♀️ Test Notification',
        body: 'This is a test notification to verify the system is working.',
        payload: 'test',
      );
      debugPrint('Test notification sent successfully');
    } catch (e) {
      debugPrint('Failed to send test notification: $e');
    }
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Failed to get pending notifications: $e');
      return [];
    }
  }
} 