import 'package:flutter/material.dart';
import 'package:proyecto_practica/core/theme/app_colors.dart'; // Paleta de colores centralizada
import 'package:proyecto_practica/screens/database_info_screen.dart';
import 'package:proyecto_practica/widgets/custom_button.dart'; // Botón personalizado reutilizable
import 'package:proyecto_practica/widgets/custom_text_field.dart'; // Campo de texto personalizado reutilizable
import 'package:proyecto_practica/widgets/login_header.dart'; // Cabecera con logo y texto
import 'package:proyecto_practica/widgets/register_prompt.dart'; // Widget para invitar a registrarse
import 'package:proyecto_practica/services/user_service.dart'; // Servicio para autenticación de usuario
import 'package:proyecto_practica/screens/start_screen.dart'; // Pantalla principal tras login
import 'package:proyecto_practica/screens/register_screen.dart'; // Pantalla de registro

/// Pantalla de inicio de sesión (login).
/// Permite al usuario ingresar sus credenciales y acceder a la app.
/// También ofrece acceso a la pantalla de registro si no tiene cuenta.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controlador para el campo de usuario
  final TextEditingController _usernameController = TextEditingController();
  // Controlador para el campo de contraseña
  final TextEditingController _passwordController = TextEditingController();
  // Clave global para el formulario, necesaria para validar los campos
  final _formKey = GlobalKey<FormState>();
  // Servicio de usuario para autenticación
  final UserService _userService = UserService();

  @override
  void dispose() {
    // Libera los controladores cuando el widget se destruye para evitar fugas de memoria
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey, // Color de fondo de la pantalla
      body: Center(
        child: SingleChildScrollView(
          // Permite desplazar el contenido si el teclado está abierto (responsive)
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
            ), // Espaciado lateral
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabecera con logo y texto de bienvenida
                const LoginHeader(
                  welcomeText: 'Bienvenido',
                  imagePath: 'assets/images/acceso.png',
                ),
                // Formulario de login
                Form(
                  key: _formKey, // Clave para validar el formulario
                  child: Column(
                    children: [
                      // Campo de texto para el usuario
                      CustomTextField(
                        label: 'Usuario',
                        controller: _usernameController,
                        validator: (value) {
                          // Valida que el campo no esté vacío
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8), // Espaciado vertical
                      // Campo de texto para la contraseña (oculta el texto)
                      CustomTextField(
                        label: 'Contraseña',
                        controller: _passwordController,
                        obscureText: true, // Oculta el texto para seguridad
                        validator: (value) {
                          // Valida que el campo no esté vacío
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32), // Espaciado antes del botón
                      // Botón para iniciar sesión
                      CustomButton(
                        text: 'Iniciar sesión',
                        onPressed: () async {
                          // Valida el formulario antes de proceder
                          if (_formKey.currentState!.validate()) {
                            final username = _usernameController.text.trim();
                            final password = _passwordController.text.trim();

                            // Intenta autenticar al usuario usando el servicio
                            final error = await _userService.loginUser(
                              username,
                              password,
                            );

                            if (!mounted) return; // Verifica que el widget sigue en el árbol

                            if (error == null) {
                              // Login correcto, navega a StartScreen
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const StartScreen(),
                                ),
                              );
                            } else {
                              // Muestra un mensaje de error si la autenticación falla
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            }
                          }
                        },
                        backgroundColor: AppColors.black,
                        textColor: AppColors.white,
                      ),
                      const SizedBox(
                        height: 8,
                      ), // Espaciado antes del nuevo botón
                      // Botón para ver información de la base de datos
                      CustomButton(
                        text: 'Ver información de la BBDD',
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DatabaseInfoScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ), // Espaciado antes del prompt de registro
                      // Widget para invitar a registrarse si no tienes cuenta
                      RegisterPrompt(
                        onTap: () {
                          // Navega a la pantalla de registro
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
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
