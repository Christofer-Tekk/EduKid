// lib/data/models/color_model.dart

class ColorModel {
  final int id;
  final String clave;
  final String nombre;
  final String nombreMayuscula;
  final String rutaImagen;
  final String rutaAudio;
  final int colorHex;
  String estado;

  ColorModel({
    required this.id,
    required this.clave,
    required this.nombre,
    required this.nombreMayuscula,
    required this.rutaImagen,
    required this.rutaAudio,
    required this.colorHex,
    this.estado = 'no_iniciado',
  });
}
