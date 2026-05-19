// lib/data/services/progreso_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class ProgresoService {
  static const String _prefixLetra = 'letra_';
  static const String _prefixColor = 'color_';

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE LETRAS
  // ─────────────────────────────────────────────────────────────

  /// Obtener estado de una letra (no_iniciado, en_progreso, completado)
  static Future<String> obtenerEstado(String letraMayuscula) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_prefixLetra$letraMayuscula') ?? 'no_iniciado';
  }

  /// Marcar letra como completada
  static Future<void> completarLetra(String letraMayuscula) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefixLetra$letraMayuscula', 'completado');
  }

  /// Marcar letra como en progreso
  static Future<void> iniciarLetra(String letraMayuscula) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefixLetra$letraMayuscula', 'en_progreso');
  }

  /// Obtener todas las letras completadas
  static Future<int> obtenerLetrasCompletadas() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    int contador = 0;

    for (final key in keys) {
      if (key.startsWith(_prefixLetra) &&
          prefs.getString(key) == 'completado') {
        contador++;
      }
    }

    return contador;
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE COLORES
  // ─────────────────────────────────────────────────────────────

  /// Obtener estado de un color (no_iniciado, en_progreso, completado)
  static Future<String> obtenerEstadoColor(String claveColor) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_prefixColor$claveColor') ?? 'no_iniciado';
  }

  /// Marcar color como completado
  static Future<void> completarColor(String claveColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefixColor$claveColor', 'completado');
  }

  /// Marcar color como en progreso
  static Future<void> iniciarColor(String claveColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefixColor$claveColor', 'en_progreso');
  }

  /// Obtener todos los colores completados
  static Future<int> obtenerColoresCompletados() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    int contador = 0;

    for (final key in keys) {
      if (key.startsWith(_prefixColor) &&
          prefs.getString(key) == 'completado') {
        contador++;
      }
    }

    return contador;
  }
}
