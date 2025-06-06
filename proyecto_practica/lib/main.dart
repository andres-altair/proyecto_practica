import 'package:flutter/material.dart';
import 'package:proyecto_practica/screens/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Función para solicitar permisos necesarios al usuario
Future<void> _requestPermissions() async {
  // Solicitar permiso de ubicación
  await Permission.location.request();
  
  // Verificar si el GPS está habilitado
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Los servicios de ubicación están desactivados.');
  }

  // Verificar y solicitar permisos de ubicación si es necesario
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos de ubicación fueron denegados');
    }
  }
}

// Función principal de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Borra la base de datos al iniciar la app (solo para pruebas/desarrollo)
  //await DatabaseHelper.instance.deleteDatabase();

  try {
    await _requestPermissions(); // Solicita permisos antes de iniciar la app
  } catch (e) {
    //print('Error al solicitar permisos: $e');
  }
  runApp(const MainApp()); // Inicia la aplicación
}

// Widget principal de la aplicación
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      home: const LoginScreen(), // Pantalla inicial: login
    );
  }
}