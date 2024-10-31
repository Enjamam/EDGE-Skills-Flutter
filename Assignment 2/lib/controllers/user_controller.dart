import 'package:get/get.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await _databaseService.initializeDatabase();
    await fetchUsers();
  }

  Future<void> fetchUsers() async {
    users.value = await _databaseService.fetchUsers();
  }

  Future<void> insertUser(String name, int age) async {
    await _databaseService.insertUser(User(name: name, age: age));
    await fetchUsers();
  }
}