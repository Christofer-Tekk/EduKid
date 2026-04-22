import 'package:flutter/material.dart';

class AppTheme {
  static const Color rojo = Color(0xFFFF4B4B);
  static const Color amarillo = Color(0xFFFFD93D);
  static const Color verde = Color(0xFF6BCB77);
  static const Color azul = Color(0xFF4D96FF);
  static const Color fondo = Color(0xFFF9F9F9);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: fondo,
    primaryColor: azul,
    fontFamily: 'Arial',

    appBarTheme: const AppBarTheme(
      backgroundColor: azul,
      centerTitle: true,
    ),
  );
}
