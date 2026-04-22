class ProgresoService {
  static final Map<String, bool> progreso = {};

  static bool estaCompleto(String id) {
    return progreso[id] ?? false;
  }

  static void completar(String id) {
    progreso[id] = true;
  }
}
