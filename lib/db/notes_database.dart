import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:exp_flutter_sqlite_crud/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init(); // GLOBAL FIELD INSTANCE
  static Database? _database;
  NotesDatabase._init(); // PRIVATE CONSTRUCTOR

  Future<Database> get database async {
    // IF YOU ARE CONFUSE ABOUT THE "!" AT THE END OF THE VARIABLE NAME GO TO THIS LINK, IT WAS CALLED BANG OPERATOR:
    // https://stackoverflow.com/questions/67667071/understanding-bang-operator-in-dart
    if (_database != null) return _database!; // IF DATABASE EXIST THEN RETURN IT

    // IF NOT, THEN INITIALIZED IT
    _database = await _initDB("notes.db");
    return _database!;
  }

  Future<Database> _initDB (String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB (Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const booleanType = "BOOLEAN NOT NULL";
    const intType = "INTEGER NOT NULL";
    const txtType = "TEXT NOT NULL";

    await db.execute(
        """
        CREATE TABLE $tableNotes (
          ${ NoteFields.id } $idType,
          ${ NoteFields.isImportant } $booleanType,
          ${ NoteFields.number } $intType,
          ${ NoteFields.title } $txtType,
          ${ NoteFields.description } $txtType,
          ${ NoteFields.time } $txtType
        )
        """
    );
  }

  Future<Note> create(Note note) async {
    final db = await instance.database; // REFERENCE TO THE DATABASE
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}