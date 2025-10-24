import 'package:flutter/material.dart';
import '../models/reminder_model.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _titleController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        // Apply custom color theme to the time picker
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7B1FA2), // header background
              onPrimary: Colors.white,    // header text
              onSurface: Colors.black87,  // body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF7B1FA2), // buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _saveReminder() {
    if (_titleController.text.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and time")),
      );
      return;
    }

    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final reminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      time: selectedDateTime,
    );

    Navigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Reminder"),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B1FA2),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Reminder Title",
                  labelStyle: const TextStyle(color: Color(0xFF7B1FA2)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7B1FA2), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTime == null
                          ? "No time selected"
                          : "Time: ${_selectedTime!.format(context)}",
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickTime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Pick Time"),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveReminder,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFF7B1FA2),
                ),
                child: const Text(
                  "Save Reminder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
