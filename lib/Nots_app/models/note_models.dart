class NoteModels {
  int? id;
  String title;
  String description;
  DateTime? date;
  bool isCompleted;
  bool isFavorite;

  NoteModels({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.date,
    this.isFavorite=false,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date?.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory NoteModels.fromMap(Map<String, dynamic> map) {
    return NoteModels(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : null,
      isFavorite: map['isFavorite'] == 1,

    );
  }
}