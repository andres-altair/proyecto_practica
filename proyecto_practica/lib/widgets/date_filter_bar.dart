import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Clase que gestiona el filtro de fechas
class DateFilterBar extends StatelessWidget {
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final Function(DateTime?) onFechaInicioChanged;
  final Function(DateTime?) onFechaFinChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const DateFilterBar({
    super.key,
    required this.fechaInicio,
    required this.fechaFin,
    required this.onFechaInicioChanged,
    required this.onFechaFinChanged,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap:
                  () => _seleccionarFecha(
                    context,
                    fechaInicio,
                    onFechaInicioChanged,
                  ),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha inicio',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  fechaInicio != null
                      ? DateFormat('dd-MM-yyyy').format(fechaInicio!)
                      : 'Seleccionar',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap:
                  () => _seleccionarFecha(context, fechaFin, onFechaFinChanged),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha fin',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  fechaFin != null
                      ? DateFormat('dd-MM-yyyy').format(fechaFin!)
                      : 'Seleccionar',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: onSearch, child: const Text('Buscar')),
          IconButton(icon: const Icon(Icons.clear), onPressed: onClear),
        ],
      ),
    );
  }

  // Selecciona una fecha
  Future<void> _seleccionarFecha(
    BuildContext context,
    DateTime? fechaActual,
    Function(DateTime?) onFechaChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaActual ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onFechaChanged(picked);
    }
  }
}
