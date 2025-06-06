import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'documents_screen.dart';
import 'package:proyecto_practica/widgets/home_button_screen.dart';
// Clase que gestiona el estado de la pantalla de inicio
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}
// Clase que gestiona el estado de la pantalla de inicio
class _StartScreenState extends State<StartScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _screens = <Widget>[
    UserProfileScreen(),
    HomeButtonScreen(),
    DocumentsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 36),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Documentos',
          ),
        ],
      ),
    );
  }
}
