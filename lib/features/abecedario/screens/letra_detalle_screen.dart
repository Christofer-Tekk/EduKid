// lib/features/abecedario/screens/letra_detalle_screen.dart

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/home_button.dart';
import '../../../data/models/letra_model.dart';
import '../../../data/services/audio_service.dart';

class LetraDetalleScreen extends StatefulWidget {
  const LetraDetalleScreen({super.key});

  @override
  State<LetraDetalleScreen> createState() => _LetraDetalleScreenState();
}

class _LetraDetalleScreenState extends State<LetraDetalleScreen> {
  YoutubePlayerController? _ytController;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_inicializado) {
      final letra = ModalRoute.of(context)?.settings.arguments as LetraModel;
      final String? videoId = YoutubePlayer.convertUrlToId(letra.urlYoutube);

      _ytController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
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
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letra = ModalRoute.of(context)?.settings.arguments as LetraModel;

    return BackgroundWrapper(
      assetPath: AppFondos.abecedario,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _TituloLetraCard(letra: letra),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HomeButton.iconOnly(),
                      const SizedBox(width: 8),
                      BotonAccion(
                        texto: 'VOLVER',
                        icono: Icons.arrow_back,
                        colorPrincipal: Colors.blue,
                        colorSombra: const Color(0xFF1971C2),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _LetrasCard(letra: letra),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
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

                    _BotonGrande(
                      texto: '🔊  ESCUCHAR',
                      color: const Color(0xFF51CF66),
                      sombra: const Color(0xFF2F9E44),
                      onTap: () => AudioService.reproducirAudio(letra.rutaAudio),
                    ),

                    const SizedBox(height: 16),

                    const _SeccionCard(texto: '🎬  Video'),
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

class _TituloLetraCard extends StatelessWidget {
  final LetraModel letra;

  const _TituloLetraCard({required this.letra});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '${letra.letraMayuscula}  ${letra.palabraEjemplo}',
          maxLines: 1,
          style: const TextStyle(
            color: ColoresApp.rojo,
            fontSize: 27,
            fontWeight: FontWeight.w900,
            shadows: SombrasApp.blanca,
          ),
        ),
      ),
    );
  }
}

class _LetrasCard extends StatelessWidget {
  final LetraModel letra;

  const _LetrasCard({required this.letra});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.90),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                letra.letraMayuscula,
                style: const TextStyle(
                  fontSize: 78,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF0000),
                  shadows: [
                    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(3, 3)),
                    Shadow(color: Colors.black38, blurRadius: 8, offset: Offset(2, 2)),
                  ],
                ),
              ),
              const SizedBox(width: 26),
              Text(
                letra.letraMinuscula,
                style: const TextStyle(
                  fontSize: 78,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  shadows: [
                    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(3, 3)),
                    Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeccionCard extends StatelessWidget {
  final String texto;

  const _SeccionCard({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.86),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: AppTexto.subtitulo(
          texto,
          textAlign: TextAlign.center,
          color: ColoresApp.azulMedio,
          shadows: SombrasApp.blanca,
        ),
      ),
    );
  }
}

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
