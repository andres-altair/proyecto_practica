import 'package:flutter/material.dart';

// Clase que gestiona el item de usuario
class UserListItem extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user['username'] ?? ''),
        subtitle: Text(
          'Empresa: ${user['empresa'] ?? ''}\n'
          'ID: ${user['id_user']}',
        ),
      ),
    );
  }
}
