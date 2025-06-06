import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// Clase que gestiona la vista de información del trabajador
class WorkerInfoView extends StatelessWidget {
  final String trabajador;
  final String empresa;
  final String vehiculo;
  final DateTime fechaHora;
  final Position? posicion;

  const WorkerInfoView({
    super.key,
    required this.trabajador,
    required this.empresa,
    required this.vehiculo,
    required this.fechaHora,
    required this.posicion,
  });

  @override
  Widget build(BuildContext context) {
    final formatoFecha = DateFormat('dd-MM-yyyy HH:mm:ss');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trabajador: $trabajador', style: const TextStyle(fontSize: 18)),
        Text('Empresa: $empresa', style: const TextStyle(fontSize: 18)),
        Text('Vehículo: $vehiculo', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Text(
          'Fecha y hora de inicio: ${formatoFecha.format(fechaHora)}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Ubicación de inicio: ${posicion != null ? '${posicion!.latitude}, ${posicion!.longitude}' : 'No disponible'}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
