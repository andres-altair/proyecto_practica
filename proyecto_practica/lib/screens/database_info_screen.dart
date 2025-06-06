import 'package:flutter/material.dart';
import 'package:proyecto_practica/services/database_service.dart';
import 'package:proyecto_practica/widgets/user_list_item.dart';
import 'package:proyecto_practica/widgets/vehicle_list_item.dart';
// Clase que gestiona el estado de la pantalla de información de la base de datos
class DatabaseInfoScreen extends StatefulWidget {
  const DatabaseInfoScreen({super.key});

  @override
  State<DatabaseInfoScreen> createState() => _DatabaseInfoScreenState();
}
// Clase que gestiona el estado de la pantalla de información de la base de datos
class _DatabaseInfoScreenState extends State<DatabaseInfoScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> vehicles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
// Carga los datos de la base de datos
  Future<void> _loadData() async {
    final usersData = await DatabaseService.instance.getUsers();
    final vehiclesData = await DatabaseService.instance.getVehicles();

    setState(() {
      users = usersData;
      vehicles = vehiclesData;
      isLoading = false;
    });
  }
// Genera la pantalla de información de la base de datos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información de la BBDD')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usuarios:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ...users.map((user) => UserListItem(user: user)),
                    const SizedBox(height: 24),
                    const Text(
                      'Vehículos:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ...vehicles.map(
                      (vehicle) => VehicleListItem(vehicle: vehicle),
                    ),
                  ],
                ),
              ),
    );
  }
}
