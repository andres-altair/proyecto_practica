import 'package:flutter/material.dart';

// Clase que gestiona el campo de texto personalizado
class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(controller: controller),
        const SizedBox(height: 16),
      ],
    );
  }
}
