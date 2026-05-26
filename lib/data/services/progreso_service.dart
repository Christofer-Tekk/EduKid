// lib/data/services/progreso_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class ProgresoService {
  static const String _prefixLetra = 'letra_';
  static const String _prefixColor = 'color_';
  static const String _prefixNumero = 'numero_';
  static const String _prefixForma = 'forma_';

  // ─────────────────────────────────────────────
  // MÉTODOS GENERALES
  // ─────────────────────────────────────────────
  static Future<String> _obtenerEstadoPorClave(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'no_iniciado';
  }

  static Future<void> _guardarEstadoPorClave(String key, String estado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, estado);
  }

  static Future<int> _contarCompletados(String prefix) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    var contador = 0;

    for (final key in keys) {
      if (key.startsWith(prefix) && prefs.getString(key) == 'completado') {
        contador++;
      }
    }

    return contador;
  }

  // ─────────────────────────────────────────────
  // ABECEDARIO
  // ─────────────────────────────────────────────
  static Future<String> obtenerEstado(String letraMayuscula) {
    return _obtenerEstadoPorClave('$_prefixLetra$letraMayuscula');
  }

  static Future<void> completarLetra(String letraMayuscula) {
    return _guardarEstadoPorClave('$_prefixLetra$letraMayuscula', 'completado');
  }

  static Future<void> iniciarLetra(String letraMayuscula) {
    return _guardarEstadoPorClave('$_prefixLetra$letraMayuscula', 'en_progreso');
  }

  static Future<int> obtenerLetrasCompletadas() {
    return _contarCompletados(_prefixLetra);
  }

  // ─────────────────────────────────────────────
  // COLORES
  // ─────────────────────────────────────────────
  static Future<String> obtenerEstadoColor(String clave) {
    return _obtenerEstadoPorClave('$_prefixColor$clave');
  }

  static Future<void> completarColor(String clave) {
    return _guardarEstadoPorClave('$_prefixColor$clave', 'completado');
  }

  static Future<void> iniciarColor(String clave) {
    return _guardarEstadoPorClave('$_prefixColor$clave', 'en_progreso');
  }

  static Future<int> obtenerColoresCompletados() {
    return _contarCompletados(_prefixColor);
  }

  // ─────────────────────────────────────────────
  // NÚMEROS
  // ─────────────────────────────────────────────
  static Future<String> obtenerEstadoNumero(int numero) {
    return _obtenerEstadoPorClave('$_prefixNumero$numero');
  }

  static Future<void> completarNumero(int numero) {
    return _guardarEstadoPorClave('$_prefixNumero$numero', 'completado');
  }

  static Future<void> iniciarNumero(int numero) {
    return _guardarEstadoPorClave('$_prefixNumero$numero', 'en_progreso');
  }

  static Future<int> obtenerNumerosCompletados() {
    return _contarCompletados(_prefixNumero);
  }

  // ─────────────────────────────────────────────
  // FORMAS
  // ─────────────────────────────────────────────
  static Future<String> obtenerEstadoForma(String clave) {
    return _obtenerEstadoPorClave('$_prefixForma$clave');
  }

  static Future<void> completarForma(String clave) {
    return _guardarEstadoPorClave('$_prefixForma$clave', 'completado');
  }

  static Future<void> iniciarForma(String clave) {
    return _guardarEstadoPorClave('$_prefixForma$clave', 'en_progreso');
  }

  static Future<int> obtenerFormasCompletadas() {
    return _contarCompletados(_prefixForma);
  }
}
