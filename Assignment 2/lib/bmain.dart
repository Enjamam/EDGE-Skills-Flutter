import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SqfliteExample(),
    );
  }
}

class SqfliteExample extends StatefulWidget {
  const SqfliteExample({super.key});

  @override
  State<SqfliteExample> createState() => _SqfliteExampleState();
}

class _SqfliteExampleState extends State<SqfliteExample> {
  late Database database;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _initializeDatabase();
    await _fetchUsers();
  }

  Future<void> _initializeDatabase() async {
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

  Future<void> _fetchUsers() async {
    final users = await database.query('users');
    setState(() {
      _users = users;
    });
  }

  Future<void> _insertUser(String name, int age) async {
    await database.insert(
      'users',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "enter name"),
              onSubmitted: (value) {
                _insertUser(value, 25);
              },
            ),
            const SizedBox(height: 20),
            _users.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text('Name: ${user['name'] ?? ""}'),
                    subtitle: Text('Age: ${user['age'] ?? ""}'),
                  );
                },
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}