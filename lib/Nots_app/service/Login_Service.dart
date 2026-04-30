import '../../Core/Utils/database.dart';
import '../models/Login_models.dart';
class LoginService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // create
  Future<int> createLogin(LoginModels loginmodels) async {
    final db = await _databaseHelper.database;
    return await db.insert('login', loginmodels.toMap());
  }

  // read
  Future<List<LoginModels>> getLogins() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('login');
    return maps.map((map) => LoginModels.fromMap(map)).toList();
  }

  // update
  Future<int> updateLogin(LoginModels loginmodels) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'login',
      loginmodels.toMap(),
      where: 'id = ?',
      whereArgs: [loginmodels.id],
    );
  }

  // delete
  Future<int> deleteLogin(LoginModels loginmodels) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'login',
      where: 'id = ?',
      whereArgs: [loginmodels.id],
    );
  }
  Future<LoginModels?> checkLogin(String email, String password) async {
    final db = await _databaseHelper.database;

    final maps = await db.query(
      'login',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return LoginModels.fromMap(maps.first);
    } else {
      return null;
    }
  }
}