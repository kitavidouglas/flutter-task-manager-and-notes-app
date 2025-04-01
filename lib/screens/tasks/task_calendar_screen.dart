import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '/providers/tasks_provider.dart';
import '/helper/notification_service.dart';

class TaskCalendarScreen extends StatefulWidget {
  @override
  _TaskCalendarScreenState createState() => _TaskCalendarScreenState();
}

class _TaskCalendarScreenState extends State<TaskCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TasksProvider>(context);
    final tasksForTheDay = taskProvider.getTasksByDate(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Calendar & Planner'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasksForTheDay.length,
              itemBuilder: (context, index) {
                final task = tasksForTheDay[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(task.description ?? 'No Description'),
                    trailing: IconButton(
                      icon: Icon(Icons.notifications_active),
                      onPressed: () => notificationService.scheduleNotification(task.title, "Task Reminder", index),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    for (int i = 0; i < 7; i++)
                      BarChartGroupData(x: i, barRods: [BarChartRodData(y: taskProvider.getTaskCountByDay(i), colors: [Colors.blue])]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
