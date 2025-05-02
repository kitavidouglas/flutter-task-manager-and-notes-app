// lib/providers/note_calendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_master/screens/notes/group_notes.dart';

import '../models/note.dart';
import '../helper/db_helper.dart';

class NoteCalendarProvider extends ChangeNotifier {
  // keyed by 'yyyy-MM-dd'
  final Map<String, List<Note>> _notesByDate = {};
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
  Map<String, List<Note>> get notesByDate => _notesByDate;

  /// Notes for the currently selected date.
  List<Note> get notesForSelectedDate {
    final key = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return _notesByDate[key] ?? [];
  }

  /// Change the calendar’s selected day.
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Load all notes from the DB and bucket them by date.
  Future<void> fetchNotes() async {
    final rawList = await DBHelper.getData('NOTES');
    _notesByDate.clear();

    for (var item in rawList) {
      final note = Note(
        id: item['id'],
        title: item['title'],
        info: item['info'],
        colorValue: item['colorValue'],
        // parse your stored date string (or fallback to today)
        date: item['date'] == ''
            ? DateTime.now()
            : DateTime.tryParse(item['date'])!,
      );

      final dateKey = DateFormat('yyyy-MM-dd').format(note.date);
      _notesByDate.putIfAbsent(dateKey, () => []).add(note);
    }

    notifyListeners();
  }

  /// Add a new note both in memory and in the SQLite table.
  Future<void> addNote(Note note) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(note.date);
    _notesByDate.putIfAbsent(dateKey, () => []);
    _notesByDate[dateKey]!.insert(0, note);

    await DBHelper.insert('NOTES', {
      'id': note.id,
      'title': note.title,
      'info': note.info,
      'colorValue': note.colorValue,
      'date': note.date.toIso8601String(),
    });

    notifyListeners();
  }

  /// Delete a note from both memory and the DB.
  Future<void> deleteNote(String noteId, DateTime noteDate) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(noteDate);
    _notesByDate[dateKey]?.removeWhere((n) => n.id == noteId);
    await DBHelper.delete(noteId);
    notifyListeners();
  }

  /// Update an existing note.
  Future<void> updateNote(Note updated) async {
    final oldKey = _notesByDate.keys.firstWhere((k) =>
        _notesByDate[k]!.any((n) => n.id == updated.id));
    _notesByDate[oldKey]!
        .removeWhere((n) => n.id == updated.id);

    final newKey = DateFormat('yyyy-MM-dd').format(updated.date);
    _notesByDate.putIfAbsent(newKey, () => []);
    _notesByDate[newKey]!.insert(0, updated);

    await DBHelper.update('NOTES', updated.id, {
      'title': updated.title,
      'info': updated.info,
      'colorValue': updated.colorValue,
      'date': updated.date.toIso8601String(),
    });

    notifyListeners();
  }

  /// Wipe all loaded notes (doesn't clear the DB).
  void clearNotes() {
    _notesByDate.clear();
    notifyListeners();
  }
}
