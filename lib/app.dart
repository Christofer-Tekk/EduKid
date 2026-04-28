import 'package:flutter/material.dart';
// Aquí llamaremos a tu nueva pantalla Home
import 'features/home/home_screen.dart'; 

class EduKidApp extends StatelessWidget {
  const EduKidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduKid',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // Inicia directamente en el menú
      home: const HomeScreen(), 
    );
  }
}