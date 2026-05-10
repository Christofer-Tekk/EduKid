// lib/data/services/audio_service.dart

import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  /// Reproducir audio de una letra
  static Future<void> reproducirAudio(String rutaAudio) async {
  try {
    // Si la ruta empieza con "assets/", lo eliminamos.
    // Esto asegura que AssetSource no cree una ruta doble ("assets/assets/...")
    String rutaLimpia = rutaAudio.startsWith('assets/') 
        ? rutaAudio.replaceFirst('assets/', '') 
        : rutaAudio;

    await _audioPlayer.play(AssetSource(rutaLimpia));
  } catch (e) {
    print('Error reproduciendo audio: $e');
  }
}

  /// Detener audio actual
  static Future<void> detenerAudio() async {
    await _audioPlayer.stop();
  }

  /// Limpiar recursos
  static void dispose() {
    _audioPlayer.dispose();
  }
}