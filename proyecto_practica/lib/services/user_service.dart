import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:proyecto_practica/core/db/database_helper.dart';

// Servicio para gestionar usuarios: registro, login y obtención de datos
class UserService {
  /// Hashea la contraseña usando SHA-256 para mayor seguridad
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Registra un usuario, su empresa y sus vehículos
  /// Devuelve null si el registro fue exitoso, o un mensaje de error si falla
  Future<String?> registerUser(String username, String password, String empresa, List<String> vehiculos) async {
    // Paso 1: validar si ya existe algún usuario
    final db = await DatabaseHelper.instance.database;
    final existingUsers = await db.query('users');
    if (existingUsers.isNotEmpty) {
      return 'Ya existe un usuario registrado. Solo se permite uno.';
    }

    // Hashea la contraseña antes de guardarla
    final hashedPassword = hashPassword(password);
    // Inserta el usuario en la base de datos
    final userId = await DatabaseHelper.instance.insertUser(username, hashedPassword, empresa);

    // Si el usuario se insertó correctamente, inserta los vehículos asociados
    if (userId > 0) {
      for (final vehiculo in vehiculos) {
        await DatabaseHelper.instance.insertVehicle(userId, vehiculo);
      }
      return null; // Registro exitoso
    } else {
      return 'Error al registrar usuario.';
    }
  }

  /// Obtiene los datos de un usuario por su nombre de usuario
  Future<Map<String, dynamic>?> getUser(String username) async {
    return await DatabaseHelper.instance.getUser(username);
  }

  /// Inicia sesión validando usuario y contraseña
  /// Devuelve null si el login es correcto, o un mensaje de error si falla
  Future<String?> loginUser(String username, String password) async {
    final user = await getUser(username);
    if (user == null) {
      return 'Usuario no encontrado';
    }
    final hashedInput = hashPassword(password);
    if (user['password'] == hashedInput) {
      return null; // Login correcto
    } else {
      return 'Contraseña incorrecta';
    }
  }
}
