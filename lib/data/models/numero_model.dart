// lib/data/models/numero_model.dart

class NumeroModel {
  final int valor;
  final String nombre;
  final String imagen;
  final String audio;
  final String videoUrl;
  bool completado;

  NumeroModel({
    required this.valor,
    required this.nombre,
    required this.imagen,
    required this.audio,
    required this.videoUrl,
    this.completado = false,
  });

  String get estado => completado ? 'completado' : 'no_iniciado';
}
