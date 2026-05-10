class NoteModels {
  int? id;
  String title;
  String description;
  DateTime? date;
  bool isCompleted;
  bool isFavorite;
  bool isLocked;

  NoteModels({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.date,
    this.isFavorite = false,
    this.isLocked = false,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date?.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
      'isLocked': isLocked ? 1 : 0,
    };
  }

  // Convert Map to object
  factory NoteModels.fromMap(Map<String, dynamic> map) {
    return NoteModels(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      date:
      map['date'] != null
          ? DateTime.parse(map['date'])
          : null,
      isFavorite: map['isFavorite'] == 1,
      isLocked: map['isLocked'] == 1,
    );
  }

  // Copy With
  NoteModels copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    bool? isFavorite,
    bool? isLocked,
  }) {
    return NoteModels(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      isFavorite: isFavorite ?? this.isFavorite,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}