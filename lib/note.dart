enum HighlightColor { yellow, pink, blue }

class Note {
  String id;
  String? title;
  String content;
  Map<int, HighlightColor> highlightedPositions;
  List<String> comments;
  DateTime creationTime;

  Note({
    required this.id,
    this.title,
    required this.content,
    List<String>? comments,
    Map<int, HighlightColor>? highlightedPositions,
    DateTime? creationTime,
  })  : this.comments = comments ?? [],
        this.highlightedPositions = highlightedPositions ?? {},
        this.creationTime = creationTime ?? DateTime.now();

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      highlightedPositions: (json['highlightedPositions']
              as Map<String, dynamic>)
          .map((key, value) =>
              MapEntry(int.parse(key), HighlightColor.values[value as int])),
      comments: (json['comments'] as List<dynamic>).cast<String>(),
      creationTime: DateTime.parse(json['creationTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'highlightedPositions': highlightedPositions
          .map((key, value) => MapEntry(key.toString(), value.index)),
      'comments': comments,
      'creationTime': creationTime.toIso8601String(),
    };
  }
}
