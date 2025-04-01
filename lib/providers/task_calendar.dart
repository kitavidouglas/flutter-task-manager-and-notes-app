import 'package:flutter/material.dart';
import '../models/user_task.dart';
import '../helper/db_helper.dart';
import 'package:intl/intl.dart';

class TaskCalendarProvider extends ChangeNotifier {
  Map<String, List<UserTask>> _tasksByDate = {};
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
  Map<String, List<UserTask>> get tasksByDate => _tasksByDate;

  List<UserTask> get tasksForSelectedDate {
    return _tasksByDate[DateFormat('yyyy-MM-dd').format(_selectedDate)] ?? [];
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    final dataList = await DBHelper.getData('USERTASK');
    _tasksByDate.clear();

    for (var item in dataList) {
      UserTask task = UserTask(
        item['id'],
        item['title'],
        item['desc'] == '' ? null : item['desc'],
        item['stDate'] == '' ? null : DateTime.tryParse(item['stDate']),
        imagePath: item['image'],
        isDone: item['isDone'] == 0 ? false : true,
      );
      
      String dateKey = DateFormat('yyyy-MM-dd').format(task.startingDate ?? DateTime.now());
      
      if (!_tasksByDate.containsKey(dateKey)) {
        _tasksByDate[dateKey] = [];
      }
      _tasksByDate[dateKey]!.add(task);
    }
    notifyListeners();
  }

  void addTask(UserTask task) async {
    String dateKey = DateFormat('yyyy-MM-dd').format(task.startingDate ?? DateTime.now());
    
    if (!_tasksByDate.containsKey(dateKey)) {
      _tasksByDate[dateKey] = [];
    }
    _tasksByDate[dateKey]!.insert(0, task);
    
    await DBHelper.insert('USERTASK', {
      'id': task.id,
      'title': task.title,
      'desc': task.description ?? '',
      'stDate': task.startingDate?.toString() ?? '',
      'image': task.imagePath,
      'isDone': 0,
    });
    
    notifyListeners();
  }

  void deleteTask(String taskId, DateTime taskDate) async {
    String dateKey = DateFormat('yyyy-MM-dd').format(taskDate);
    _tasksByDate[dateKey]?.removeWhere((task) => task.id == taskId);
    await DBHelper.delete(taskId);
    notifyListeners();
  }

  void markTaskAsDone(String taskId, DateTime taskDate, bool isDone) async {
    String dateKey = DateFormat('yyyy-MM-dd').format(taskDate);
    
    _tasksByDate[dateKey]?.firstWhere((task) => task.id == taskId).isDone = isDone;
    int val = isDone ? 1 : 0;
    await DBHelper.update(taskId, val);
    notifyListeners();
  }

  void clearTasks() {
    _tasksByDate.clear();
    notifyListeners();
  }
}