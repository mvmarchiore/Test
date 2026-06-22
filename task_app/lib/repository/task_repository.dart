import 'package:sqflite/sqflite.dart';

import '../database/connection_db.dart';
import '../model/task.dart';

class TaskRepository {
  Future<int> create(Task task) async {
    final Database db = await ConnectionDb.instance.database;

    return await db.insert(
      'tasks',
      task.toMap(),
    );
  }

  Future<List<Task>> getAll() async {
    final Database db = await ConnectionDb.instance.database;

    final result = await db.query('tasks');

    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<Task?> getById(int id) async {
    final Database db = await ConnectionDb.instance.database;

    final result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Task.fromMap(result.first);
    }

    return null;
  }

  Future<int> update(Task task) async {
    final Database db = await ConnectionDb.instance.database;

    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await ConnectionDb.instance.database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}