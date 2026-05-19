// lib/features/colores/controllers/colores_controller.dart

import 'package:flutter/material.dart';

import '../../../data/local/datos_colores.dart';
import '../../../data/models/color_model.dart';
import '../../../data/services/progreso_service.dart';

class ColoresController extends ChangeNotifier {
  List<ColorModel> colores = [];
  int completados = 0;
  bool cargando = true;

  ColoresController() {
    cargarColores();
  }

  Future<void> cargarColores() async {
    cargando = true;
    notifyListeners();

    colores = datosColores
        .map(
          (color) => ColorModel(
            id: color.id,
            clave: color.clave,
            nombre: color.nombre,
            nombreMayuscula: color.nombreMayuscula,
            rutaImagen: color.rutaImagen,
            rutaAudio: color.rutaAudio,
            colorHex: color.colorHex,
            estado: color.estado,
          ),
        )
        .toList();

    for (final color in colores) {
      color.estado = await ProgresoService.obtenerEstadoColor(color.clave);
    }

    completados = colores.where((color) => color.estado == 'completado').length;
    cargando = false;
    notifyListeners();
  }

  Future<void> completarColor(String clave) async {
    await ProgresoService.completarColor(clave);

    for (final color in colores) {
      if (color.clave == clave) {
        color.estado = 'completado';
        break;
      }
    }

    completados = colores.where((color) => color.estado == 'completado').length;
    notifyListeners();
  }
}
