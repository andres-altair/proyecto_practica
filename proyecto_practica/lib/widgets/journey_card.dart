import 'package:flutter/material.dart';
import 'dart:typed_data';

// Clase que gestiona la tarjeta de la jornada
class JourneyCard extends StatelessWidget {
  final Map<String, dynamic> jornada;
  final String fechaInicio;
  final String fechaFin;
  final VoidCallback onDownloadPDF;
  final VoidCallback onPrint;

  const JourneyCard({
    super.key,
    required this.jornada,
    required this.fechaInicio,
    required this.fechaFin,
    required this.onDownloadPDF,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    final firmaBytes = jornada['firma'] as Uint8List?;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trabajador: ${jornada['trabajador']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Empresa: ${jornada['empresa']}'),
            Text('Vehículo: ${jornada['vehiculo']}'),
            const SizedBox(height: 8),
            Text('Fecha y hora de inicio: $fechaInicio'),
            Text(
              'Ubicación de inicio: ${jornada['lat_inicio']}, ${jornada['lon_inicio']}',
            ),
            const SizedBox(height: 8),
            Text('Fecha y hora de fin: $fechaFin'),
            Text(
              'Ubicación de fin: ${jornada['lat_fin']}, ${jornada['lon_fin']}',
            ),
            const SizedBox(height: 8),
            const Text('Firma:', style: TextStyle(fontWeight: FontWeight.bold)),
            firmaBytes != null && firmaBytes.isNotEmpty
                ? Image.memory(firmaBytes, height: 100)
                : const Text('Sin firma'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Descargar PDF'),
                    onPressed: onDownloadPDF,
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text('Imprimir'),
                    onPressed: onPrint,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
