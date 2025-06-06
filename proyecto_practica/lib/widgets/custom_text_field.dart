import 'package:flutter/material.dart';

// Clase que gestiona el campo de texto personalizado
class CustomTextField extends StatelessWidget {
  // Etiqueta que se muestra sobre el campo de texto
  final String label;
  // Controlador para gestionar el texto introducido
  final TextEditingController controller;
  // Si es true, oculta el texto (ideal para contraseñas)
  final bool obscureText;
  // Función de validación personalizada (puede ser null)
  final String? Function(String?)? validator;
  // Tipo de teclado a mostrar (por defecto texto)
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Controlador del campo
      obscureText: obscureText, // Oculta el texto si es necesario (contraseña)
      keyboardType: keyboardType, // Tipo de teclado
      decoration: InputDecoration(
        labelText: label, // Etiqueta del campo
        border: const OutlineInputBorder(), // Borde del campo
      ),
      validator: validator, // Función de validación
    );
  }
}