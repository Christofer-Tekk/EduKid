import 'package:flutter/material.dart';
import '../constants/app_constants.dart'; // Importa tus constantes

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String assetPath; // <--- Esta variable permite cambiar el fondo

  const BackgroundWrapper({
    super.key, 
    required this.child, 
    this.assetPath = AppFondos.principal, // Si no pones nada, usa el de login/menú
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Bloquea el movimiento del teclado
      body: Stack(
        children: [
          // FONDO DINÁMICO
          Positioned.fill(
            child: Image.asset(
              assetPath, // <--- Aquí se carga el fondo que tú elijas
              fit: BoxFit.cover,
            ),
          ),
          child, // El contenido de tu pantalla (botones, juegos, etc)
        ],
      ),
    );
  }
}