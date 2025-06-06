import 'package:flutter/material.dart';
import 'package:proyecto_practica/core/theme/app_colors.dart';

// Clase que gestiona el botón personalizado
class CustomButton extends StatelessWidget {
  // Texto que se muestra en el botón
  final String text;
  // Función que se ejecuta al presionar el botón
  final VoidCallback onPressed;
  // Indica si el botón es primario (no se usa en esta versión, pero se puede usar para variantes)
  final bool isPrimary;
  // Color de fondo del botón (opcional)
  final Color? backgroundColor;
  // Color del texto del botón (opcional)
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // El botón ocupa todo el ancho disponible
      child: ElevatedButton(
        onPressed: onPressed, // Acción al presionar el botón
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48), // Altura mínima del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
          ),
          backgroundColor: backgroundColor ?? AppColors.black, // Color de fondo (por defecto negro)
          foregroundColor: textColor ?? AppColors.white, // Color del texto (por defecto blanco)
        ),
        child: Text(
          text, // Texto del botón
          style: TextStyle(
            color: textColor ?? AppColors.white, // Color del texto
            fontWeight: FontWeight.bold, // Texto en negrita
            fontSize: 16, // Tamaño de fuente
          ),
        ),
      ),
    );
  }
}