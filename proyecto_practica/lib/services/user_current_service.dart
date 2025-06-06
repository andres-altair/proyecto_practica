import 'package:proyecto_practica/core/db/database_helper.dart';

class UserCurrentService {
  static final UserCurrentService instance = UserCurrentService._init();

  UserCurrentService._init();

  /// Obtiene el usuario actual (único usuario en el sistema)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query('users');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Obtiene los vehículos asociados a un usuario
  Future<List<Map<String, dynamic>>> getUserVehicles(int userId) async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(
      'vehicles',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Actualiza el perfil del usuario y sus vehículos
  Future<void> updateUserProfile({
    required int userId,
    required String username,
    required String empresa,
    required List<String> vehiculos,
  }) async {
    final db = await DatabaseHelper.instance.database;

    // Actualiza los datos del usuario
    await db.update(
      'users',
      {'username': username, 'empresa': empresa},
      where: 'id_user = ?',
      whereArgs: [userId],
    );

    // Actualiza los vehículos
    await db.delete('vehicles', where: 'user_id = ?', whereArgs: [userId]);
    for (final vehiculo in vehiculos) {
      if (vehiculo.trim().isNotEmpty) {
        await db.insert('vehicles', {'nombre': vehiculo, 'user_id': userId});
      }
    }
  }
}
