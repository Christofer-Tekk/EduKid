// lib/features/abecedario/screens/letra_detalle_screen.dart

import 'package:flutter/material.dart';
// 1. Cambiamos la importación de webview por youtube_player
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../data/models/letra_model.dart';
import '../../../data/services/audio_service.dart';

class LetraDetalleScreen extends StatefulWidget {
  const LetraDetalleScreen({super.key});

  @override
  State<LetraDetalleScreen> createState() => _LetraDetalleScreenState();
}

class _LetraDetalleScreenState extends State<LetraDetalleScreen> {
  // 2. Usamos el controlador oficial de YouTube
  YoutubePlayerController? _ytController;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Inicializamos el controlador solo una vez al entrar
    if (!_inicializado) {
      final letra = ModalRoute.of(context)?.settings.arguments as LetraModel;
      
      // Convertimos la URL de YouTube a un ID de video automáticamente
      final String? videoId = YoutubePlayer.convertUrlToId(letra.urlYoutube);

      _ytController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false, // El video no empieza solo para no asustar al niño
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    // 3. ¡MUY IMPORTANTE! Liberar el controlador al salir para evitar errores de memoria
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letra = ModalRoute.of(context)?.settings.arguments as LetraModel;

    return BackgroundWrapper(
      assetPath: 'assets/images/fondo/fondo_abecedario.png',
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTexto.titulo('${letra.letraMayuscula}  ${letra.palabraEjemplo}'),
                  BotonAccion(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back,
                    colorPrincipal: Colors.blue,
                    colorSombra: const Color(0xFF1971C2),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // ── LETRAS MAYÚSCULA Y MINÚSCULA ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          letra.letraMayuscula,
                          style: const TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF0000),
                            shadows: [
                              Shadow(color: Colors.black87, blurRadius: 0, offset: Offset(3, 3)),
                              Shadow(color: Colors.black45, blurRadius: 10),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          letra.letraMinuscula,
                          style: const TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: Colors.black87, blurRadius: 0, offset: Offset(3, 3)),
                              Shadow(color: Colors.black45, blurRadius: 10),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── IMAGEN GRANDE ──
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          letra.rutaImagen,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── BOTÓN AUDIO ──
                    _BotonGrande(
                      texto: '🔊  ESCUCHAR',
                      color: const Color(0xFF51CF66),
                      sombra: const Color(0xFF2F9E44),
                      onTap: () => AudioService.reproducirAudio(letra.rutaAudio),
                    ),

                    const SizedBox(height: 16),

                    // ── VIDEO YOUTUBE ──
                    const AppTexto.subtitulo('🎬  Video'),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black38, blurRadius: 8),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        // 4. Reemplazamos WebViewWidget por YoutubePlayer
                        child: _ytController != null 
                          ? YoutubePlayer(
                              controller: _ytController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.red,
                              progressColors: const ProgressBarColors(
                                playedColor: Colors.red,
                                handleColor: Colors.redAccent,
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── BOTÓN PRACTICAR ──
                    _BotonGrande(
                      texto: '✏️  PRACTICAR',
                      color: const Color(0xFF339AF0),
                      sombra: const Color(0xFF1971C2),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/letra_practica',
                          arguments: letra,
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón grande reutilizable dentro de esta pantalla
class _BotonGrande extends StatefulWidget {
  final String texto;
  final Color color;
  final Color sombra;
  final VoidCallback onTap;

  const _BotonGrande({
    required this.texto,
    required this.color,
    required this.sombra,
    required this.onTap,
  });

  @override
  State<_BotonGrande> createState() => _BotonGrandeState();
}

class _BotonGrandeState extends State<_BotonGrande> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _presionado = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: double.infinity,
        margin: EdgeInsets.only(
          top: _presionado ? 5 : 0,
          bottom: _presionado ? 0 : 5,
        ),
        decoration: BoxDecoration(
          color: widget.sombra,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(
            widget.texto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
            ),
          ),
        ),
      ),
    );
  }
}