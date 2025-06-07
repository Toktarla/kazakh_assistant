import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:proj_management_project/services/remote/firestore_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../config/di/injection_container.dart';


class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static const androidDetails = AndroidNotificationDetails(
    'daily_notification_channel',
    'Let\'s grind!',
    icon: "@mipmap/launcher_icon", // Replace with your launcher icon
    channelDescription: 'Get notified to grind',
    importance: Importance.high,
    priority: Priority.high,
  );

  static void initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const InitializationSettings initializationSettingsAndroid = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/launcher_icon")
    );

    await _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {
          print("onDidReceiveNotificationResponse, ${details.input} !!! ${details}");
        }
      },
    );

    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    print("Notifications Granted: $granted");
  }

  static Future<void> scheduleDailyMotivationalMessage({int hour = 15, int minute = 0, String localeCode = 'en'}) async {

    const notificationDetails = NotificationDetails(android: androidDetails);

    final appDataBoxManager = sl<FirestoreService>();
    final message = await appDataBoxManager.fetchRandomMotivation(localeCode);
    final scheduledTime = _nextInstanceOfTime(hour, minute);

    print("Scheduling notification for: $scheduledTime");

    await _notificationsPlugin.zonedSchedule(
      0,
      message?['title'] ?? "",
      message?['body'] ?? "",
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("Notification scheduled successfully.");
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = const NotificationDetails(
          android: androidDetails
      );
      await _notificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['route']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}