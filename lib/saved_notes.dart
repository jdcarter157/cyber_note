import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';
import 'edit_note_screen.dart';

class SavedNotesScreen extends StatefulWidget {
  @override
  _SavedNotesScreenState createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadSavedNotes();
  }

  Future<void> _loadSavedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedNotes = prefs.getStringList('notes') ?? [];
    setState(() {
      _notes = savedNotes
          .map((noteJson) {
            try {
              return Note.fromJson(jsonDecode(noteJson));
            } catch (e) {
              print('Error decoding note: $e');
              // If the note is not a JSON string, treat it as regular text
              if (noteJson.startsWith("{")) {
                return null;
              } else {
                DateTime now = DateTime.now();
                return Note(
                    id: now.millisecondsSinceEpoch.toString(),
                    title: now.toString(),
                    content: noteJson);
              }
            }
          })
          .where((note) => note != null)
          .toList()
          .cast<Note>();
    });
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> noteJsonList =
        _notes.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList('notes', noteJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (BuildContext context, int index) {
          Note note = _notes[index];
          return Card(
            child: ListTile(
              title: Text(
                note.title,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: note.content
                      .split('')
                      .asMap()
                      .entries
                      .map(
                        (entry) => TextSpan(
                          text: entry.value,
                          style: note.highlightedPositions
                                  .containsKey(entry.key)
                              ? TextStyle(
                                  backgroundColor: () {
                                    switch (
                                        note.highlightedPositions[entry.key]) {
                                      case HighlightColor.yellow:
                                        return Colors.yellow;
                                      case HighlightColor.pink:
                                        return Colors.pink;
                                      case HighlightColor.blue:
                                        return Colors.blue;
                                      default:
                                        return Colors.yellow;
                                    }
                                  }(),
                                  color: Colors.black,
                                )
                              : TextStyle(color: Colors.black),
                        ),
                      )
                      .toList(),
                  style: DefaultTextStyle.of(context).style,
                ),
              ),
              onTap: () async {
                Note? updatedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(note: note),
                  ),
                );
                if (updatedNote != null) {
                  setState(() {
                    _notes[index] = updatedNote;
                  });
                  _saveNotes();
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DateTime now = DateTime.now();
          Note newNote = Note(
            id: now.millisecondsSinceEpoch.toString(),
            title: now.toString(),
            content: '',
          );
          Note? updatedNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(note: newNote),
            ),
          );
          if (updatedNote != null) {
            setState(() {
              _notes.add(updatedNote);
            });
            _saveNotes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
