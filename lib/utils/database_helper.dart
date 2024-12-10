import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.noteTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        modified_at TEXT NOT NULL,
        color_index INTEGER NOT NULL,
        is_pinned INTEGER NOT NULL,
        tags TEXT NOT NULL,
        attachments TEXT,
        is_locked INTEGER NOT NULL
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(AppConstants.noteTable, note.toMap());
    return note.copy(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query(
      AppConstants.noteTable,
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      AppConstants.noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      AppConstants.noteTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      AppConstants.noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete(AppConstants.noteTable);
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await instance.database;
    final result = await db.query(
      AppConstants.noteTable,
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
