

import '../../core/utils/database.dart';
import '../models/task_model.dart';

class TaskService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;


  //create
  Future<int> createTask(TaskModel taskModel) async {
    final db = await _databaseHelper.database;
    print(taskModel.toMap());
    final id = await db.insert('tasks', taskModel.toMap());
    print(id);
    return id;
  }

  //read tasks and convert to objects
  Future<List<TaskModel>> getTasks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks'); //list of maps
    print(maps);
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  //update
  Future<int> updateTask(TaskModel taskModel) async {
    final db = await _databaseHelper.database;
    final id = await db.update('tasks',
        taskModel.toMap(), where: 'id = ?', whereArgs: [taskModel.id]);
    return id;
  }

  //delete
  Future<int> deleteTask(TaskModel taskModel) async {
    final db = await _databaseHelper.database;
    final id = await db.delete('tasks', where: 'id = ?', whereArgs: [taskModel.id]);
    return id;
  }
}

