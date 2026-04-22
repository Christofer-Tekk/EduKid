import 'package:flutter/material.dart';
// 1. Aquí importamos el archivo que acabas de crear
import 'features/abecedario/screens/letra_practica_screen.dart';

void main() {
  runApp(const EduKidApp());
}

class EduKidApp extends StatelessWidget {
  const EduKidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja de "DEBUG"
      title: 'EduKid - Práctica',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // 2. AQUÍ ESTÁ LA MAGIA: Le decimos que la pantalla de inicio (home) sea tu pizarra
      // Le pasamos la letra 'A' como parámetro para probar
      home: const LetraPracticaScreen(letra: 'A'), 
    );
  }
}