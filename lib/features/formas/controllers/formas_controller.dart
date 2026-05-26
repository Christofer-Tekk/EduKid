// lib/features/formas/controllers/formas_controller.dart

import 'package:flutter/material.dart';

import '../../../data/local/datos_formas.dart';
import '../../../data/models/forma_model.dart';
import '../../../data/services/progreso_service.dart';

class FormasController extends ChangeNotifier {
  List<FormaModel> formas = [];
  int completados = 0;
  bool cargando = true;

  FormasController() {
    cargarFormas();
  }

  Future<void> cargarFormas() async {
    cargando = true;
    notifyListeners();

    formas = datosFormas
        .map(
          (forma) => FormaModel(
            id: forma.id,
            clave: forma.clave,
            nombre: forma.nombre,
            nombreMayuscula: forma.nombreMayuscula,
            rutaImagen: forma.rutaImagen,
            rutaAudio: forma.rutaAudio,
            colorHex: forma.colorHex,
            shapeType: forma.shapeType,
            estado: forma.estado,
          ),
        )
        .toList();

    for (final forma in formas) {
      forma.estado = await ProgresoService.obtenerEstadoForma(forma.clave);
    }

    completados = formas.where((f) => f.estado == 'completado').length;
    cargando = false;
    notifyListeners();
  }

  Future<void> completarForma(String clave) async {
    await ProgresoService.completarForma(clave);

    for (final forma in formas) {
      if (forma.clave == clave) {
        forma.estado = 'completado';
        break;
      }
    }

    completados = formas.where((f) => f.estado == 'completado').length;
    notifyListeners();
  }
}
