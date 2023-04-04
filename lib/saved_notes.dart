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
  Map<HighlightColor, Color> _highlightColors = {
    HighlightColor.yellow: Colors.yellow,
    HighlightColor.pink: Colors.pinkAccent,
    HighlightColor.blue: Colors.lightBlueAccent,
  };
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
                    content: noteJson,
                    highlightedPositions: {},
                    comments: [],
                    creationTime: now);
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
          String noteTitle =
              note.title ?? _formatTimestamp(note.creationTime).toUpperCase();
          return Card(
            child: ListTile(
              title: Text(
                noteTitle,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: _getHighlightedTextSpans(note),
                    ),
                  ),
                  ..._getCommentWidgets(note),
                ],
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
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: '',
            highlightedPositions: {},
            comments: [],
            creationTime: now,
            title: _formatTimestamp(now),
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

  List<InlineSpan> _getHighlightedTextSpans(Note note) {
    List<InlineSpan> spans = [];
    List<String> contentChars = note.content.split('');
    Map<int, HighlightColor> highlightedPositions = note.highlightedPositions;
    int startIndex = 0;
    highlightedPositions.forEach((position, color) {
      if (startIndex < position) {
        spans.add(TextSpan(
          text: contentChars.sublist(startIndex, position).join(),
        ));
      }
      spans.add(TextSpan(
        text: contentChars[position],
        style: TextStyle(
          backgroundColor: _highlightColors[color] ?? Colors.yellow,
          color: Colors.black,
        ),
      ));
      startIndex = position + 1;
    });

    if (startIndex < contentChars.length) {
      spans.add(TextSpan(
        text: contentChars.sublist(startIndex).join(),
      ));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(
        text: note.content,
      ));
    }

    return [TextSpan(text: 'Note: '), ...spans];
  }

  List<Widget> _getCommentWidgets(Note note) {
    List<Widget> widgets = [];
    for (String comment in note.comments) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(comment),
        ),
      );
    }
    return widgets;
  }

  String _formatTimestamp(DateTime timestamp) {
    String amPm = timestamp.hour < 12 ? 'AM' : 'PM';
    int hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    String minute =
        timestamp.minute < 10 ? '0${timestamp.minute}' : '${timestamp.minute}';
    String month =
        timestamp.month < 10 ? '0${timestamp.month}' : '${timestamp.month}';
    String day = timestamp.day < 10 ? '0${timestamp.day}' : '${timestamp.day}';
    return '$hour:$minute $amPm - $day/$month/${timestamp.year}';
  }
}
