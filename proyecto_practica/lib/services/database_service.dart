import 'package:proyecto_practica/core/db/database_helper.dart';

// Clase que gestiona la base de datos
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  // Obtiene todos los usuarios de la base de datos
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('users');
  }

  // Obtiene todos los vehículos de la base de datos
  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('vehicles');
  }
}
