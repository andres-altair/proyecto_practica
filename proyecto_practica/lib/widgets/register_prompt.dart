import 'package:flutter/material.dart';
import 'package:proyecto_practica/core/theme/app_colors.dart';

// Clase que gestiona el prompt de registro
class RegisterPrompt extends StatelessWidget {
  // Callback que se ejecuta al pulsar en "Registrarse"
  final VoidCallback onTap;

  const RegisterPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido horizontalmente
      children: [
        // Texto informativo
        const Text(
          '¿No te has registrado? ',
          style: TextStyle(fontSize: 14, color: AppColors.black),
        ),
        // Texto "Registrarse" que actúa como enlace
        GestureDetector(
          onTap: onTap, // Ejecuta la función al pulsar
          child: const Text(
            'Registrarse',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // Subrayado para parecer enlace
              decorationColor: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}