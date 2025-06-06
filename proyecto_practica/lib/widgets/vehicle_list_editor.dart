import 'package:flutter/material.dart';

// Clase que gestiona el editor de lista de vehículos
class VehicleListEditor extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAddVehicle;

  const VehicleListEditor({
    super.key,
    required this.controllers,
    required this.onAddVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vehículos:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Vehículo ${index + 1}'),
            ),
          );
        }),
        TextButton.icon(
          onPressed: onAddVehicle,
          icon: const Icon(Icons.add),
          label: const Text('Añadir otro vehículo'),
        ),
      ],
    );
  }
}
