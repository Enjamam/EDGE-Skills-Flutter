import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';

class DatabaseService {
  late Database database;

  Future<void> initializeDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'user.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<List<User>> fetchUsers() async {
    final List<Map<String, dynamic>> maps = await database.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<void> insertUser(User user) async {
    await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}