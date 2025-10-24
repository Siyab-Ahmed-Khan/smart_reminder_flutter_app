import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(const SmartReminderApp());
}

class SmartReminderApp extends StatelessWidget {
  const SmartReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Reminder App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
