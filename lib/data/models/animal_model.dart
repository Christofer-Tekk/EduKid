// lib/data/models/animal_model.dart

class AnimalModel {
  final String clave;
  final String nombre;
  final String imagen;
  final String imagenSf;
  final String audioNombre;

  String estado;

  AnimalModel({
    String? clave,
    required this.nombre,
    required this.imagen,
    required this.imagenSf,
    required this.audioNombre,
    String? estado,
    bool completado = false,
  })  : clave = clave ?? nombre.toLowerCase(),
        estado = estado ?? (completado ? 'completado' : 'no_iniciado');

  bool get completado => estado == 'completado';

  set completado(bool value) {
    estado = value ? 'completado' : 'no_iniciado';
  }
}