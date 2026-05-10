// lib/features/abecedario/controllers/abecedario_controller.dart

import 'package:flutter/material.dart';
import '../../../data/local/datos_abecedario.dart';
import '../../../data/models/letra_model.dart';
import '../../../data/services/progreso_service.dart';

class AbecedarioController extends ChangeNotifier {
  List<LetraModel> letras = [];
  int letrasCompletadas = 0;

  AbecedarioController() {
    cargarLetras();
  }

  /// Cargar todas las letras y sus estados
  Future<void> cargarLetras() async {
    letras = DatosAbecedario.obtenerLetras();
    
    // Cargar estado de cada letra desde SharedPreferences
    for (var letra in letras) {
      letra.estado = await ProgresoService.obtenerEstado(letra.letraMayuscula);
    }
    
    letrasCompletadas = await ProgresoService.obtenerLetrasCompletadas();
    notifyListeners();
  }

  /// Marcar letra como completada
  Future<void> completarLetra(String letraMayuscula) async {
    await ProgresoService.completarLetra(letraMayuscula);
    
    // Actualizar la lista local
    final index = letras.indexWhere((l) => l.letraMayuscula == letraMayuscula);
    if (index != -1) {
      letras[index].estado = 'completado';
    }
    
    letrasCompletadas = await ProgresoService.obtenerLetrasCompletadas();
    notifyListeners();
  }
}