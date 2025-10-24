import 'package:flutter/material.dart';
import 'add_reminder_screen.dart';
import '../models/reminder_model.dart';
import '../services/notification_service.dart';
import '../utils/time_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Reminder> reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Reminder App"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: reminders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notifications_off, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "No reminders yet.\nTap + to add one.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          final remaining = TimeHelper.remainingTime(reminder.time);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text(
                  reminder.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "Reminds at: ${reminder.time.hour.toString().padLeft(2, '0')}:${reminder.time.minute.toString().padLeft(2, '0')} | $remaining left",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      reminders.removeAt(index);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newReminder = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReminderScreen()),
          );
          if (newReminder != null && newReminder is Reminder) {
            setState(() {
              reminders.add(newReminder);
            });

            // Schedule notification
            NotificationService().scheduleNotification(newReminder);
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
