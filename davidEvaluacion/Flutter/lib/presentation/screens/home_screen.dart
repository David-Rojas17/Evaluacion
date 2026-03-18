import 'dart:math';

import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/constants/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _randomMessages = [
    '¡Bienvenido! Aquí esta nuestro home proximo a desarrollarse.',
    '¡Hola! Disfruta de tu experiencia en nuestra app de evaluación.',
  ];

  late String _message;

  @override
  void initState() {
    super.initState();
    _message = _getRandomMessage();
  }

  String _getRandomMessage() {
    final random = Random();
    return _randomMessages[random.nextInt(_randomMessages.length)];
  }

  Future<void> _logout() async {
    await AuthRepository().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.home_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenido a Home',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _message = _getRandomMessage();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Mostrar otra info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
