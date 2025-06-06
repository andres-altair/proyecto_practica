import 'package:flutter/material.dart';
import 'package:proyecto_practica/core/theme/app_colors.dart';
import 'package:proyecto_practica/widgets/custom_button.dart';
import 'package:proyecto_practica/widgets/custom_text_field.dart';
import 'package:proyecto_practica/widgets/login_header.dart';
import 'package:proyecto_practica/services/user_service.dart';
import 'package:proyecto_practica/core/db/database_helper.dart'; // Import necesario para limpiar DB y mostrar datos

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controlador para el campo de usuario
  final TextEditingController _usernameController = TextEditingController();
  // Controlador para el campo de contraseña
  final TextEditingController _passwordController = TextEditingController();
  // Controlador para el campo de empresa
  final TextEditingController _empresaController = TextEditingController();
  // Lista de controladores para los campos de vehículos (permite múltiples vehículos)
  final List<TextEditingController> _vehiculoControllers = [TextEditingController()];

  // Clave global para el formulario, necesaria para validar los campos
  final _formKey = GlobalKey<FormState>();
  // Servicio de usuario para registro
  final UserService _userService = UserService();

  // Método para añadir un nuevo campo de vehículo dinámicamente
  void _addVehiculoField() {
    setState(() {
      _vehiculoControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    // Libera los controladores cuando el widget se destruye para evitar fugas de memoria
    _usernameController.dispose();
    _passwordController.dispose();
    _empresaController.dispose();
    for (final controller in _vehiculoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            iconSize: 50,
            onPressed: () {
              Navigator.of(context).pop(); // Vuelve a la pantalla anterior
            },
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabecera con imagen y texto de registro
                const LoginHeader(
                  welcomeText: 'Regístrate',
                  imagePath: 'assets/images/crear-una-cuenta.png',
                ),
                // Formulario de registro
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo de texto para el usuario
                      CustomTextField(
                        label: 'Usuario',
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Campo de texto para la contraseña (oculta el texto)
                      CustomTextField(
                        label: 'Contraseña',
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Campo de texto para la empresa
                      CustomTextField(
                        label: 'Empresa',
                        controller: _empresaController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre de la empresa';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Campos dinámicos para los vehículos
                      Column(
                        children: [
                          ..._vehiculoControllers.asMap().entries.map((entry) {
                            final index = entry.key;
                            final controller = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CustomTextField(
                                label: 'Vehículo ${index + 1}',
                                controller: controller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa el vehículo ${index + 1}';
                                  }
                                  return null;
                                },
                              ),
                            );
                          }),
                          // Botón para añadir otro campo de vehículo
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _addVehiculoField,
                              icon: const Icon(Icons.add),
                              label: const Text('Añadir otro vehículo'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Botón para registrar el usuario
                      CustomButton(
                        text: 'Registrarse',
                        onPressed: () async {
                          // Valida el formulario antes de proceder
                          if (_formKey.currentState!.validate()) {
                            final username = _usernameController.text.trim();
                            final password = _passwordController.text.trim();
                            final empresa = _empresaController.text.trim();
                            final vehiculos = _vehiculoControllers.map((c) => c.text.trim()).toList();

                            // Llama al servicio para registrar el usuario y vehículos
                            final error = await _userService.registerUser(username, password, empresa, vehiculos);

                            if (error == null) {
                              await DatabaseHelper.instance.printAllData(); // ✅ Ver datos en consola
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Usuario registrado correctamente')),
                              );
                              Navigator.of(context).pop(); // Vuelve a la pantalla anterior
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            }
                          }
                        },
                        backgroundColor: AppColors.black,
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
