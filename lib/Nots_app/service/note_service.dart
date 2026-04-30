

import 'package:note/Nots_app/models/note_models.dart';
import '../../Core/Utils/database.dart';




class NoteService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;


  //create
  Future<int> createNots(NoteModels notemodels) async {
    final db = await _databaseHelper.database;
    print(notemodels.toMap());
    final id = await db.insert('nots', notemodels.toMap());
    print(id);
    return id;
  }

  //read tasks and convert to objects
  Future<List<NoteModels>> getNots() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('nots'); //list of maps
    print(maps);
    return maps.map((map) => NoteModels.fromMap(map)).toList();
  }

  //update
  Future<int> updateNots(NoteModels notemodels) async {
    final db = await _databaseHelper.database;
    final id = await db.update('nots',
        notemodels.toMap(), where: 'id = ?', whereArgs: [notemodels.id]);
    return id;
  }

  //delete
  Future<int> deleteNots(NoteModels notemodels) async {
    final db = await _databaseHelper.database;
    final id = await db.delete('nots', where: 'id = ?', whereArgs: [notemodels.id]);
    return id;
  }
}

