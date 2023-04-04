enum HighlightColor { yellow, pink, blue }

class Note {
  String id;
  String title;
  String content;
  Map<int, HighlightColor> highlightedPositions;
  List<String> comments;

  Note({
    required this.id,
    required this.title,
    required this.content,
    List<String>? comments,
    Map<int, HighlightColor>? highlightedPositions,
  })  : this.comments = comments ?? [],
        this.highlightedPositions = highlightedPositions ?? {};

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      comments: List<String>.from(json['comments'] ?? []),
      highlightedPositions: (json['highlightedPositions']
              as Map<String, dynamic>)
          .map((key, value) =>
              MapEntry(int.parse(key), HighlightColor.values[value as int])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'comments': comments,
      'highlightedPositions': highlightedPositions
          .map((key, value) => MapEntry(key.toString(), value.index)),
    };
  }
}
