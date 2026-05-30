// lib/features/animales/controllers/animales_controller.dart

import 'package:flutter/material.dart';

import '../../../data/local/datos_animales.dart';
import '../../../data/models/animal_model.dart';
import '../../../data/services/progreso_service.dart';

class AnimalesController extends ChangeNotifier {
  List<AnimalModel> animales = [];
  int animalesCompletados = 0;
  bool cargando = false;

  Future<void> cargarAnimales() async {
    cargando = true;
    notifyListeners();

    animales = listaAnimales;

    for (final animal in animales) {
      animal.estado = await ProgresoService.obtenerEstadoAnimal(animal.clave);
    }

    animalesCompletados = await ProgresoService.obtenerAnimalesCompletados();

    cargando = false;
    notifyListeners();
  }

  Future<void> completarAnimal(String clave) async {
    await ProgresoService.completarAnimal(clave);

    for (final animal in animales) {
      if (animal.clave == clave) {
        animal.completado = true;
        break;
      }
    }

    animalesCompletados = await ProgresoService.obtenerAnimalesCompletados();
    notifyListeners();
  }
}
