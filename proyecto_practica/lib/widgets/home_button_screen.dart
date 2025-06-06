import 'package:flutter/material.dart';
import 'package:proyecto_practica/screens/database_info_screen.dart';
import 'package:proyecto_practica/screens/finish_screen.dart';
import 'package:proyecto_practica/services/start_screen_service.dart';

// Clase que gestiona la pantalla de inicio
class HomeButtonScreen extends StatefulWidget {
  const HomeButtonScreen({super.key});

  @override
  State<HomeButtonScreen> createState() => _HomeButtonScreenState();
}
// Clase que gestiona el estado de la pantalla de inicio
class _HomeButtonScreenState extends State<HomeButtonScreen> {
  final StartScreenService _startService = StartScreenService.instance;

  Future<void> _recogerInfo(BuildContext context) async {
    final info = await _startService.recogerInformacionJornada();
    final vehiculos = info['vehiculos'] as List<String>;
    String? vehiculoSeleccionado;

    if (vehiculos.length > 1) {
      vehiculoSeleccionado = await showDialog<String>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Selecciona un vehículo'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(vehiculos[index].toString()),
                      onTap:
                          () => Navigator.of(
                            context,
                          ).pop(vehiculos[index].toString()),
                    );
                  },
                ),
              ),
            ),
      );
      if (vehiculoSeleccionado == null) return;
    } else if (vehiculos.length == 1) {
      vehiculoSeleccionado = vehiculos.first.toString();
    } else {
      vehiculoSeleccionado = 'Desconocido';
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => FinishScreen(
              fechaHora: info['fechaHora'],
              posicion: info['posicion'],
              trabajador: info['nombre'],
              empresa: info['empresa'],
              vehiculo: vehiculoSeleccionado ?? 'Desconocido',
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _recogerInfo(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              textStyle: const TextStyle(fontSize: 24),
            ),
            child: const Text('INICIO'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DatabaseInfoScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            ),
            child: const Text('Ver información de la BBDD'),
          ),
        ],
      ),
    );
  }
}
