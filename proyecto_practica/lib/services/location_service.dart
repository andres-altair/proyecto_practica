import 'package:geolocator/geolocator.dart';

// Servicio para obtener la ubicación del dispositivo
class LocationService {
  // Método estático para obtener la ubicación actual una sola vez
  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // Alta precisión para la ubicación
      ),
    );
  }

  // Método estático para obtener un stream de ubicaciones (actualizaciones continuas)
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // Alta precisión para la ubicación
        distanceFilter: 10, // Notifica solo si se mueve más de 10 metros
      ),
    );
  }
}
