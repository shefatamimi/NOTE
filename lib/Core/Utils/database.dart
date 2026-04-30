import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper.init();
  static Database? _database;
  DatabaseHelper.init();

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await initDB('notes.db');
    return _database!;

  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); //
    final fullPath = join(dbPath, filePath);//
    return await openDatabase(fullPath,version: 2,onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE nots(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      isCompleted INTEGER,
      date TEXT
      )
    ''');
    await db.execute('''
  CREATE TABLE login(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT,
  password TEXT
  )
''');


  }
  //create
  Future<int> insert(String table, Map<String, Object> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }
  //read
  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  //update
  Future<int> update(String table, Map<String, Object> data, int id) async {
    final db = await instance.database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  //delete
  Future<int> delete(String table, String id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  //chek
  Future<List<Map<String, dynamic>>> check(
      String table, String email, String password) async {
    final db = await instance.database;
    return await db.query(
      table,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
  }





}