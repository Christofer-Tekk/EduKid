// lib/features/numeros/controllers/numeros_controller.dart

import 'package:flutter/material.dart';

import '../../../data/local/datos_numeros.dart';
import '../../../data/models/numero_model.dart';
import '../../../data/services/progreso_service.dart';

class NumerosController extends ChangeNotifier {
  List<NumeroModel> numeros = [];
  int numerosCompletados = 0;

  NumerosController() {
    cargarNumeros();
  }

  Future<void> cargarNumeros() async {
    numeros = DatosNumeros.obtenerNumeros();

    for (final numero in numeros) {
      final estado = await ProgresoService.obtenerEstadoNumero(numero.valor);
      numero.completado = estado == 'completado';
    }

    numerosCompletados = await ProgresoService.obtenerNumerosCompletados();
    notifyListeners();
  }

  Future<void> completarNumero(int valor) async {
    await ProgresoService.completarNumero(valor);

    final index = numeros.indexWhere((numero) => numero.valor == valor);

    if (index != -1) {
      numeros[index].completado = true;
    }

    numerosCompletados = await ProgresoService.obtenerNumerosCompletados();
    notifyListeners();
  }
}
