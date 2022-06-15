final String tableNotes = "notes"; // TABLE NAME IN DATABASE

class NoteFields {
  static const List<String> values = [
    // ADD ALL FIELDS
    id, isImportant, number, title, description, time
  ];

  // COLUMN NAMES IN DATABASE
  static const String id = "_id";
  static const String isImportant = "isImportant";
  static const String number = "number";
  static const String title = "title";
  static const String description = "description";
  static const String time = "time";
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime
  });

  Note copy({ int? id, bool? isImportatnt, int? number, String? title, String? description, DateTime? createdTime }) => Note(
    id: id ?? this.id,
    isImportant: isImportatnt ?? this.isImportant,
    number: number ?? this.number,
    title: title ?? this.title,
    description: description ?? this.description,
    createdTime: createdTime ?? this.createdTime
  );

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json[NoteFields.id] as int?, // json[NoteFields.id] WAS CONVERTED INTO INTEGER
    isImportant: json[NoteFields.isImportant] == 1,
    number: json[NoteFields.number] as int, // json[NoteFields.number] WAS CONVERTED INTO INTEGER
    title: json[NoteFields.title] as String, // json[NoteFields.title] WAS CONVERTED INTO STRING
    description: json[NoteFields.description] as String, // json[NoteFields.description] WAS CONVERTED INTO STRING
    createdTime: DateTime.parse(json[NoteFields.time] as String)
  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.isImportant: isImportant ? 1 : 0, // TERNARY OPERATOR
    NoteFields.number: number,
    NoteFields.description: description,
    NoteFields.time: createdTime.toIso8601String() // THIS WILL CONVERT DateTime INTO String
  };
}