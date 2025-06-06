import 'package:flutter/material.dart';
import 'package:proyecto_practica/services/user_current_service.dart';
import 'package:proyecto_practica/widgets/profile_text_field.dart';
import 'package:proyecto_practica/widgets/vehicle_list_editor.dart';
// Clase que gestiona el estado de la pantalla de perfil de usuario
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}
// Clase que gestiona el estado de la pantalla de perfil de usuario
class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  List<TextEditingController> _vehiculoControllers = [];
  bool isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carga los datos del usuario
  Future<void> _loadUserData() async {
    final user = await UserCurrentService.instance.getCurrentUser();
    if (user != null) {
      _userId = user['id_user'] as int;
      _usernameController.text = (user['username'] ?? '').toString();
      _empresaController.text = (user['empresa'] ?? '').toString();

      final vehicles = await UserCurrentService.instance.getUserVehicles(_userId!);
      _vehiculoControllers =
          vehicles.map((v) {
            final c = TextEditingController();
            c.text = (v['nombre'] ?? '').toString();
            return c;
          }).toList();

      if (_vehiculoControllers.isEmpty) {
        _vehiculoControllers.add(TextEditingController());
      }
    }
    setState(() => isLoading = false);
  }

  // Guarda los cambios del usuario
  Future<void> _saveChanges() async {
    if (_userId == null) return;

    await UserCurrentService.instance.updateUserProfile(
      userId: _userId!,
      username: _usernameController.text.trim(),
      empresa: _empresaController.text.trim(),
      vehiculos: _vehiculoControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados correctamente')),
    );
  }

  // Añade un nuevo campo de vehículo
  void _addVehiculoField() {
    setState(() => _vehiculoControllers.add(TextEditingController()));
  }

  // Libera los controladores cuando el widget se destruye para evitar fugas de memoria
  @override
  void dispose() {
    _usernameController.dispose();
    _empresaController.dispose();
    for (final c in _vehiculoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Construye la pantalla de perfil de usuario
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileTextField(
              label: 'Nombre de usuario:',
              controller: _usernameController,
            ),
            ProfileTextField(label: 'Empresa:', controller: _empresaController),
            VehicleListEditor(
              controllers: _vehiculoControllers,
              onAddVehicle: _addVehiculoField,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
