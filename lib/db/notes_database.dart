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
    print(">>> DATABASE WAS INITIALIZED");
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
    print(">>> DATABASE WAS CREATED");
  }

  //=====================================================================================>>> SQLITE CREATE
  Future<Note> create(Note note) async {
    final db = await instance.database; // REFERENCE TO THE DATABASE
    final id = await db.insert(tableNotes, note.toJson());
    print(">>> SQLITE CREATE FUNCTION WAS CALLED");
    return note.copy(id: id);
  }

  //=====================================================================================>>> SQLITE READ (READING SINGLE RECORD)
  Future<Note> readNote(int id) async {
    final db = await instance.database; // REFERENCE TO THE DATABASE
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      // where: "${ NoteFields.id } = $id" DO NOT USE THIS BECAUSE IT WAS NOT SECURE, IT DOES NOT PREVENT SQL INJECTIONS
      where: "${ NoteFields.id } = ?", // INSTEAD USE THIS
      whereArgs: [id]
    );

    print(">>> SQLITE READ (ONE RECORD) FUNCTION WAS CALLED");

    // CHECK IF REQUEST IS SUCCESSFUL AND RETURNING SOME VALUE
    if (maps.isNotEmpty) { return Note.fromJson(maps.first); } // WE'RE TRYING TO READ ONE RECORD ONLY
    else { throw Exception("ID $id not found"); }
  }

  //=====================================================================================>>> SQLITE READ (READING MULTIPLE RECORD)
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database; // REFERENCE TO THE DATABASE
    const orderBy = "${ NoteFields.time } ASC";
    final result = await db.query(tableNotes, orderBy: orderBy);
    print(">>> SQLITE READ (MULTIPLE RECORD) FUNCTION WAS CALLED");
    return result.map((json) => Note.fromJson(json)).toList();
  }

  //=====================================================================================>>> SQLITE UPDATE
  Future<int> update (Note note) async {
    final db = await instance.database; // REFERENCE TO THE DATABASE

    print(">>> SQLITE UDPATE FUNCTION WAS CALLED");
    return db.update(
      tableNotes,
      note.toJson(),
      where: "${ NoteFields.id } = ?",
      whereArgs: [ note.id ]
    );
  }

  //=====================================================================================>>> SQLITE DELETE
  Future<int> delete (int id) async {
    final db = await instance.database; // REFERENCE TO THE DATABASE

    print(">>> SQLITE DELETE FUNCTION WAS CALLED");
    return await db.delete(
      tableNotes,
      where: "${ NoteFields.id } = ?",
      whereArgs: [ id ]
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}