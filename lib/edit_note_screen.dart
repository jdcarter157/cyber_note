import 'package:flutter/material.dart';
import 'note.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
