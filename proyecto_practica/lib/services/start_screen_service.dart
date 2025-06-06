import 'package:geolocator/geolocator.dart';
import 'package:proyecto_practica/core/db/database_helper.dart';

// Clase que gestiona el servicio de la pantalla de inicio
class StartScreenService {
  static final StartScreenService instance = StartScreenService._internal();

  StartScreenService._internal();

  // Recoge la información de la jornada
  Future<Map<String, dynamic>> recogerInformacionJornada() async {
    final ahora = DateTime.now();
    Position? posicion;

    try {
      posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      posicion = null;
    }

    final usuario = await DatabaseHelper.instance.getUniqueUser();
    final nombre = usuario?['username'] ?? 'Desconocido';
    final empresa = usuario?['empresa'] ?? 'Desconocida';
    final userId = usuario?['id_user'];

    List<String> vehiculos = [];
    if (userId != null) {
      final db = await DatabaseHelper.instance.database;
      final vehiculosResult = await db.query(
        'vehicles',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      vehiculos =
          vehiculosResult.map((row) => row['nombre'] as String).toList();
    }

    return {
      'fechaHora': ahora,
      'posicion': posicion,
      'nombre': nombre,
      'empresa': empresa,
      'vehiculos': vehiculos,
    };
  }
}
