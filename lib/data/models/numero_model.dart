class NumeroModel {
  final int valor;
  final String nombre;
  final String imagen;
  final String audio;
  final String videoUrl; // Aquí irán los links de YouTube luego

  NumeroModel({
    required this.valor,
    required this.nombre,
    required this.imagen,
    required this.audio,
    required this.videoUrl,
  });
}