// lib/data/models/forma_model.dart

class FormaModel {
  final int id;
  final String clave;
  final String nombre;
  final String nombreMayuscula;
  final String rutaImagen;
  final String rutaAudio;
  final int colorHex;
  final int shapeType; // índice de la forma para dibujarla con CustomPaint
  String estado;

  FormaModel({
    required this.id,
    required this.clave,
    required this.nombre,
    required this.nombreMayuscula,
    required this.rutaImagen,
    required this.rutaAudio,
    required this.colorHex,
    required this.shapeType,
    this.estado = 'no_iniciado',
  });
}
