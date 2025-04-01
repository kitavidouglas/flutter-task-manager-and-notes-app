import 'package:flutter/material.dart';
import '/helper/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService notificationService = NotificationService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Generate a simple notification id based on title hash code.
  int _generateNotificationId(String title) {
    return title.hashCode % 10000;
  }

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = 50.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Notification Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: bodyController,
                        decoration: const InputDecoration(
                          labelText: 'Notification Body',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.message),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: () {
                  final title = titleController.text.trim();
                  final body = bodyController.text.trim();
                  if (title.isNotEmpty && body.isNotEmpty) {
                    notificationService.sendNotification(title, body);
                    _showSnackBar('Notification Sent!');
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Send Notification'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, buttonHeight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  final title = titleController.text.trim();
                  final body = bodyController.text.trim();
                  if (title.isNotEmpty && body.isNotEmpty) {
                    final id = _generateNotificationId(title);
                    notificationService.scheduleNotification(title, body, id);
                    _showSnackBar('Daily Notification Scheduled!');
                  }
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Schedule Daily Notification'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, buttonHeight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    final id = _generateNotificationId(title);
                    notificationService.stopNotification(id);
                    _showSnackBar('Scheduled Notification Stopped!');
                  }
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Stop Scheduled Notification'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, buttonHeight),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  notificationService.stopAllNotification();
                  _showSnackBar('All Notifications Stopped!');
                },
                icon: const Icon(Icons.cancel_schedule_send),
                label: const Text('Stop All Notifications'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, buttonHeight),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
