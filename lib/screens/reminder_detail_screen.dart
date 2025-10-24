import 'package:flutter/material.dart';
import '../models/reminder_model.dart';
import '../services/notification_service.dart';
import 'add_reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reminder> reminders = [];

  void _addReminder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddReminderScreen()),
    );

    if (result != null && result is Reminder) {
      setState(() {
        reminders.add(result);
      });
      // Schedule notification
      await NotificationService().scheduleNotification(result);
    }
  }

  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Reminder App"),
      ),
      body: reminders.isEmpty
          ? const Center(child: Text("No reminders yet."))
          : ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(reminder.title),
              subtitle: Text(
                "Time: ${TimeOfDay.fromDateTime(reminder.time).format(context)}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteReminder(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
