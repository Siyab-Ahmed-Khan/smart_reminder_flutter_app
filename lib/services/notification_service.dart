import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Initialize timezone support
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi')); // Change timezone if needed
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    final scheduledDate = tz.TZDateTime.from(reminder.time, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id, // Use unique reminder ID
      'Reminder Alert',
      reminder.title,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // optional for recurring
    );
  }
}
