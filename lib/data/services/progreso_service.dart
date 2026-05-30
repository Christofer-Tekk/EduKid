// lib/data/services/progreso_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgresoService {
  static const String _prefixLetra = 'letra_';
  static const String _prefixColor = 'color_';
  static const String _prefixNumero = 'numero_';
  static const String _prefixForma = 'forma_';
  static const String _prefixAnimal = 'animal_';

  /// Devuelve el prefijo del usuario actual para separar el progreso
  /// entre cuentas distintas en el mismo celular.
  ///
  /// Ejemplo final:
  /// uid123_letra_A
  /// uid123_color_rojo
  /// uid123_numero_1
  static String _prefijoUsuario() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      return 'sin_usuario';
    }

    return uid;
  }

  static String _crearClaveUsuario(String prefix, String clave) {
    return '${_prefijoUsuario()}_${prefix}$clave';
  }

  static Future<String> _obtenerEstadoPorClave(
    String prefix,
    String clave,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _crearClaveUsuario(prefix, clave);

    return prefs.getString(key) ?? 'no_iniciado';
  }

  static Future<void> _guardarEstadoPorClave(
    String prefix,
    String clave,
    String estado,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _crearClaveUsuario(prefix, clave);

    await prefs.setString(key, estado);
  }

  static Future<int> _contarCompletados(String prefix) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final userPrefix = '${_prefijoUsuario()}_$prefix';

    int contador = 0;

    for (final key in keys) {
      if (key.startsWith(userPrefix) && prefs.getString(key) == 'completado') {
        contador++;
      }
    }

    return contador;
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE LETRAS
  // ─────────────────────────────────────────────────────────────

  static Future<String> obtenerEstado(String letraMayuscula) {
    return _obtenerEstadoPorClave(_prefixLetra, letraMayuscula);
  }

  static Future<void> completarLetra(String letraMayuscula) {
    return _guardarEstadoPorClave(_prefixLetra, letraMayuscula, 'completado');
  }

  static Future<void> iniciarLetra(String letraMayuscula) {
    return _guardarEstadoPorClave(_prefixLetra, letraMayuscula, 'en_progreso');
  }

  static Future<int> obtenerLetrasCompletadas() {
    return _contarCompletados(_prefixLetra);
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE COLORES
  // ─────────────────────────────────────────────────────────────

  static Future<String> obtenerEstadoColor(String claveColor) {
    return _obtenerEstadoPorClave(_prefixColor, claveColor);
  }

  static Future<void> completarColor(String claveColor) {
    return _guardarEstadoPorClave(_prefixColor, claveColor, 'completado');
  }

  static Future<void> iniciarColor(String claveColor) {
    return _guardarEstadoPorClave(_prefixColor, claveColor, 'en_progreso');
  }

  static Future<int> obtenerColoresCompletados() {
    return _contarCompletados(_prefixColor);
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE NÚMEROS
  // ─────────────────────────────────────────────────────────────

  static Future<String> obtenerEstadoNumero(int numero) {
    return _obtenerEstadoPorClave(_prefixNumero, numero.toString());
  }

  static Future<void> completarNumero(int numero) {
    return _guardarEstadoPorClave(
      _prefixNumero,
      numero.toString(),
      'completado',
    );
  }

  static Future<void> iniciarNumero(int numero) {
    return _guardarEstadoPorClave(
      _prefixNumero,
      numero.toString(),
      'en_progreso',
    );
  }

  static Future<int> obtenerNumerosCompletados() {
    return _contarCompletados(_prefixNumero);
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE FORMAS
  // ─────────────────────────────────────────────────────────────

  static Future<String> obtenerEstadoForma(String claveForma) {
    return _obtenerEstadoPorClave(_prefixForma, claveForma);
  }

  static Future<void> completarForma(String claveForma) {
    return _guardarEstadoPorClave(_prefixForma, claveForma, 'completado');
  }

  static Future<void> iniciarForma(String claveForma) {
    return _guardarEstadoPorClave(_prefixForma, claveForma, 'en_progreso');
  }

  static Future<int> obtenerFormasCompletadas() {
    return _contarCompletados(_prefixForma);
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESO DE ANIMALES
  // ─────────────────────────────────────────────────────────────

  static Future<String> obtenerEstadoAnimal(String claveAnimal) {
    return _obtenerEstadoPorClave(_prefixAnimal, claveAnimal);
  }

  static Future<void> completarAnimal(String claveAnimal) {
    return _guardarEstadoPorClave(_prefixAnimal, claveAnimal, 'completado');
  }

  static Future<void> iniciarAnimal(String claveAnimal) {
    return _guardarEstadoPorClave(_prefixAnimal, claveAnimal, 'en_progreso');
  }

  static Future<int> obtenerAnimalesCompletados() {
    return _contarCompletados(_prefixAnimal);
  }
}
