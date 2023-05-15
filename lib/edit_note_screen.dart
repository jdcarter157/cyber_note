import 'package:flutter/material.dart';
import 'note.dart';
import 'sum_api.dart';
import 'trans_api.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _contentController;
  late Map<HighlightColor, Color> _highlightColors;
  late TextEditingController _commentsController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
    _highlightColors = {
      HighlightColor.yellow: Colors.yellow,
      HighlightColor.pink: Colors.pink,
      HighlightColor.blue: Colors.blue,
    };
    _commentsController = TextEditingController();
  }

  void _addComment([String? apiComment]) async {
    String comment = apiComment ?? _commentsController.text.trim();
    if (comment.isEmpty) {
      try {
        // Get a summary of the note's content
        String summary = await getSummary(_contentController.text);
        // Add the comment and summary to the note
        setState(() {
          widget.note.comments.add('$comment - Summary: $summary');
        });
        _commentsController.clear();
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  void _addTranslation([String? apiTranslation]) async {
    String comment = apiTranslation ?? _commentsController.text.trim();
    if (comment.isEmpty) {
      try {
        // Get a summary of the note's content
        String translation = await getTranslation(_contentController.text);
        // Add the comment and summary to the note
        setState(() {
          widget.note.comments.add('$comment - Summary: $translation');
        });
        _commentsController.clear();
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.note.content = _contentController.text;
              Navigator.pop(context, widget.note);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _contentController,
                minLines: 1,
                maxLines: null,
                decoration: InputDecoration.collapsed(hintText: 'Note content'),
              ),
              SizedBox(height: 20),
              Text('Select text to highlight, then choose a color:'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _highlightColors.entries.map((entry) {
                  return ElevatedButton(
                    onPressed: () {
                      int start = _contentController.selection.start;
                      int end = _contentController.selection.end;

                      if (start >= 0 && end >= 0 && start != end) {
                        setState(() {
                          for (int i = start; i < end; i++) {
                            widget.note.highlightedPositions[i] = entry.key;
                          }
                        });
                      }
                    },
                    child: Text(entry.key.toString().split('.')[1]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: entry.value,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _commentsController,
                minLines: 1,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Add a comment',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String comment = _commentsController.text.trim();
                  if (comment.isNotEmpty) {
                    setState(() {
                      widget.note.comments.add(comment);
                    });
                    _commentsController.clear();
                  }
                },
                child: Text('Add Comment'),
              ),
              ElevatedButton(
                onPressed: _addComment,
                child: Text('Add Comment with API'),
              ),
              ElevatedButton(
                onPressed: _addTranslation,
                child: Text('Add Translation with API'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
