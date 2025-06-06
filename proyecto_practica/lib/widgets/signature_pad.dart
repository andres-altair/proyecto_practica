import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

// Clase que gestiona el campo de firma 
class SignaturePad extends StatelessWidget {
  final SignatureController controller;
  final VoidCallback onClear;

  const SignaturePad({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firma digital:', style: TextStyle(fontSize: 18)),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          height: 150,
          child: Signature(
            controller: controller,
            backgroundColor: Colors.white,
          ),
        ),
        Row(
          children: [
            TextButton(onPressed: onClear, child: const Text('Borrar firma')),
          ],
        ),
      ],
    );
  }
}
