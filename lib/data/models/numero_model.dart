class NumeroModel {
  final int valor;
  final String nombre;
  final String imagen;
  final String audio;
  final String videoUrl;
  bool completado; // ¡Nuevo! Para saber si ya tiene estrellita

  NumeroModel({
    required this.valor,
    required this.nombre,
    required this.imagen,
    required this.audio,
    required this.videoUrl,
    this.completado = false, // Por defecto empieza sin estrella
  });
}