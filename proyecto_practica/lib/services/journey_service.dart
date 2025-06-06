import 'package:geolocator/geolocator.dart';
import 'package:proyecto_practica/core/db/database_helper.dart';
import 'dart:typed_data';

// Clase que gestiona la jornada
class JornadaService {
  // Singleton
  static final JornadaService instance = JornadaService._internal();
  JornadaService._internal();

  // Finaliza la jornada
  Future<void> finalizarJornada({
    required String trabajador,
    required String empresa,
    required String vehiculo,
    required DateTime fechaHoraInicio,
    required Position? posicionInicio,
    required Uint8List? firma,
    required String cliente,
    required String direccionCliente,
    required String cif,
    required String localidadCliente,
    required String provinciaCliente,
    required String cp,
    required String trabajoRealizado,
  }) async {
    Position? posicionFinal;
    try {
      posicionFinal = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      posicionFinal = null;
    }

    final fechaHoraFin = DateTime.now();

    // 🔹 Obtener datos del usuario (empresa, nombre, etc.)
    final usuario = await DatabaseHelper.instance.getUniqueUser();

    await DatabaseHelper.instance.insertJornada({
      'trabajador': trabajador,
      'empresa': empresa,
      'vehiculo': vehiculo,
      'fecha_hora_inicio': fechaHoraInicio.toIso8601String(),
      'lat_inicio': posicionInicio?.latitude,
      'lon_inicio': posicionInicio?.longitude,
      'fecha_hora_fin': fechaHoraFin.toIso8601String(),
      'lat_fin': posicionFinal?.latitude,
      'lon_fin': posicionFinal?.longitude,
      'firma': firma,
      'cliente': cliente,
      'direccion_cliente': direccionCliente,
      'cif': cif,
      'localidad_cliente': localidadCliente,
      'provincia_cliente': provinciaCliente,
      'cp': cp,
      'trabajo_realizado': trabajoRealizado,

      // 🔹 Campos adicionales necesarios para el PDF
      'nombre_empresa': usuario?['empresa'],
      'direccion_empresa': 'Calle Ficticia 123', // Puedes ajustarlo dinámicamente
      'cif_empresa': 'B12345678',
      'nombre_trabajador': usuario?['username'],
      'dni_trabajador': '12345678A',
      'fecha': fechaHoraFin.toIso8601String().split('T').first,
      'hora_llegada': fechaHoraInicio.toIso8601String().split('T').last.substring(0,5),
      'hora_salida': fechaHoraFin.toIso8601String().split('T').last.substring(0,5),
      'numero_parte': '${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  // Obtiene todas las jornadas
  Future<List<Map<String, dynamic>>> obtenerJornadas({
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final db = await DatabaseHelper.instance.database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (desde != null && hasta != null) {
      where = 'fecha_hora_inicio >= ? AND fecha_hora_inicio <= ?';
      whereArgs = [desde.toIso8601String(), hasta.toIso8601String()];
    } else if (desde != null) {
      where = 'fecha_hora_inicio >= ?';
      whereArgs = [desde.toIso8601String()];
    } else if (hasta != null) {
      where = 'fecha_hora_inicio <= ?';
      whereArgs = [hasta.toIso8601String()];
    }

    return await db.query(
      'jornadas',
      orderBy: 'fecha_hora_inicio DESC',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
  }
}
