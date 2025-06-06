import 'package:flutter/material.dart';

// Clase que gestiona el item de vehículo
class VehicleListItem extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleListItem({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(vehicle['nombre'] ?? ''),
        subtitle: Text(
          'ID: ${vehicle['id']}, Usuario ID: ${vehicle['user_id']}',
        ),
      ),
    );
  }
}
