import 'package:flutter/material.dart';

// Clase que gestiona el header de login
class LoginHeader extends StatelessWidget {
  // Texto de bienvenida que se muestra debajo del logo
  final String welcomeText;
  // Ruta de la imagen/logo a mostrar
  final String imagePath;
  // Altura del logo
  final double imageHeight;

  /// Widget de cabecera para pantallas de login y registro.
  /// [welcomeText] es el texto de bienvenida (por defecto: "Bienvenido").
  /// [imagePath] es la ruta del logo a mostrar (por defecto: 'assets/images/acceso.png').
  /// [imageHeight] es la altura del logo (por defecto: 150).
  const LoginHeader({
    super.key,
    this.welcomeText = 'Bienvenido',
    this.imagePath = 'assets/images/acceso.png',
    this.imageHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Muestra el logo con la altura especificada
        Image.asset(imagePath, height: imageHeight),
        const SizedBox(height: 8), // Espacio vertical entre el logo y el texto
        // Texto de bienvenida personalizado
        Text(
          welcomeText,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 32), // Espacio vertical debajo del header
      ],
    );
  }
}