// lib/data/models/letra_model.dart

class LetraModel {
  final int id;
  final String letraMayuscula;  // "A"
  final String letraMinuscula;   // "a"
  final String palabraEjemplo;   // "Avión"
  final String rutaImagen;       // "assets/images/abecedario/a.png"
  final String rutaAudio;        // "assets/audio/abecedario/a.mp3"
  final String urlYoutube;       // "https://youtube.com/..."
  String estado;                 // "no_iniciado", "en_progreso", "completado"

  LetraModel({
    required this.id,
    required this.letraMayuscula,
    required this.letraMinuscula,
    required this.palabraEjemplo,
    required this.rutaImagen,
    required this.rutaAudio,
    required this.urlYoutube,
    this.estado = 'no_iniciado',
  });
}