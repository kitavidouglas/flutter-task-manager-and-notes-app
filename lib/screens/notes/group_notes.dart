// lib/screens/group_notes.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master/screens/notes/group_notes.dart';
import '/providers/notes_provider.dart';
import '/models/note.dart';
import '/screens/add_note_screen.dart';

class GroupNotesScreen extends StatelessWidget {
  static const routeName = '/group-notes';
  final Color groupColor;
  final String groupTitle;

  const GroupNotesScreen({
    Key? key,
    required this.groupColor,
    required this.groupTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    // filter notes by matching color value
    final filtered = notesProvider.getNotesByColor(groupColor);

    return Scaffold(
      appBar: AppBar(title: Text(groupTitle)),
      body: filtered.isEmpty
          ? Center(child: Text('No notes in this group yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final note = filtered[i];
                return Card(
                  color: Color(note.colorValue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.info,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // navigate to edit or detail view
                      Navigator.of(context).pushNamed(
                        AddNote.routeName,
                        arguments: {
                          'id': note.id,
                          'color': Color(note.colorValue),
                        },
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open add note pre-selecting group color
          Navigator.of(context).pushNamed(
            AddNote.routeName,
            arguments: {'presetColor': groupColor},
          );
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }
}


// lib/providers/notes_provider.dart (add this method inside NotesProvider class)
  /// Returns notes matching the given color
  List<Note> getNotesByColor(Color color) {
    return _notes.where((n) => n.colorValue == color.value).toList();
  }


// lib/models/note.dart (ensure it has these fields)
class Note {
  final String id;
  final String title;
  final String info;
  final int colorValue;

  Note({
    required this.id,
    required this.title,
    required this.info,
    required this.colorValue,
  });
}


// lib/screens/add_note_screen.dart (update to handle arguments)
@override
void didChangeDependencies() {
  if (_isInit) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args.containsKey('presetColor')) {
        noteColor = args['presetColor'] as Color;
      }
      if (args.containsKey('id')) {
        // load existing note into controllers for edit
        final existing = Provider.of<NotesProvider>(context, listen: false)
            .findById(args['id'] as String);
        titleController.text = existing.title;
        infoController.text = existing.info;
        noteColor = Color(existing.colorValue);
        _isEditing = true;
        _editingId = existing.id;
      }
    }
  }
  _isInit = false;
  super.didChangeDependencies();
}

void _submit(BuildContext context) {
  // ... existing validation ...
  if (_isEditing) {
    Provider.of<NotesProvider>(context, listen: false)
        .updateNote(_editingId!, title, info, noteColor);
  } else {
    Provider.of<NotesProvider>(context, listen: false)
        .addNote(title, info, noteColor);
  }
  Navigator.of(context).pop();
}


// lib/main.dart (register route)
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes & Tasks',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        AddNote.routeName: (_) => AddNote(),
        GroupNotesScreen.routeName: (_) => GroupNotesScreen(
              groupColor: Colors.white, // dummy, real via args
              groupTitle: '',
            ),
      },
    );
  }
}

// To navigate, pass arguments:
// Navigator.of(context).pushNamed(
//   GroupNotesScreen.routeName,
//   arguments: {'groupColor': Colors.yellow, 'groupTitle': 'Yellow Notes'},
// );
