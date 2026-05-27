class AnimalModel {
  final String nombre;
  final String imagen;
  final String imagenSf;
  final String audioNombre; // Único audio que usaremos
  bool completado;

  AnimalModel({
    required this.nombre,
    required this.imagen,
    required this.imagenSf,
    required this.audioNombre,
    this.completado = false,
  });
}