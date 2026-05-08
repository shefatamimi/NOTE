import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../Core/Utils/database.dart';

class BackupService {

  // أخذ نسخة احتياطية
  static Future<String> createBackup() async {
    try {
      final db = await DatabaseHelper.instance.database;

      String dbPath = db.path;
      File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception("Database file not found");
      }

      final dir = await getApplicationDocumentsDirectory();
      String backupPath = '${dir.path}/backup_notes.db';

      await dbFile.copy(backupPath);

      return backupPath;
    } catch (e) {
      throw Exception('Backup failed: $e');
    }
  }

  // استرجاع النسخة الاحتياطية
  static Future<void> restoreBackup() async {
    try {
      final db = await DatabaseHelper.instance.database;

      String dbPath = db.path;

      final dir = await getApplicationDocumentsDirectory();
      String backupPath = '${dir.path}/backup_notes.db';

      File backupFile = File(backupPath);

      if (!await backupFile.exists()) {
        throw Exception("Backup file not found");
      }

      await backupFile.copy(dbPath);

    } catch (e) {
      throw Exception('Restore failed: $e');
    }
  }
}