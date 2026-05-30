// lib/features/numeros/screens/numero_detalle_screen.dart

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';
import '../../../data/models/numero_model.dart';
import '../../../data/services/audio_service.dart';

class NumeroDetalleScreen extends StatefulWidget {
  const NumeroDetalleScreen({super.key});

  @override
  State<NumeroDetalleScreen> createState() => _NumeroDetalleScreenState();
}

class _NumeroDetalleScreenState extends State<NumeroDetalleScreen> {
  late NumeroModel numero;
  YoutubePlayerController? _youtubeController;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inicializado) return;

    numero = ModalRoute.of(context)!.settings.arguments as NumeroModel;

    final videoId = YoutubePlayer.convertUrlToId(numero.videoUrl) ?? numero.videoUrl;

    if (videoId.trim().isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }

    _inicializado = true;
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    AudioService.detenerAudio();
    super.dispose();
  }

  Future<void> _reproducirAudio() async {
    await AudioService.reproducirAudio(numero.audio);
  }

  void _irAPractica() {
    _youtubeController?.pause();

    Navigator.pushNamed(
      context,
      '/numero_practica',
      arguments: numero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.numeros,
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
                      child: _TituloNumeroCard(
                        texto: '${numero.valor} ${numero.nombre}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const HomeButton.iconOnly(),
                  const SizedBox(width: 10),
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
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                child: Column(
                  children: [
                    _NumeroImagenCard(numero: numero),
                    const SizedBox(height: 18),
                    BotonAccion(
                      texto: 'ESCUCHAR',
                      icono: Icons.volume_up,
                      colorPrincipal: const Color(0xFF51CF66),
                      colorSombra: const Color(0xFF2B8A3E),
                      onPressed: _reproducirAudio,
                    ),
                    const SizedBox(height: 18),
                    const _VideoTitulo(),
                    const SizedBox(height: 10),
                    _VideoCard(controller: _youtubeController),
                    const SizedBox(height: 18),
                    BotonAccion(
                      texto: 'PRACTICAR',
                      icono: Icons.edit,
                      colorPrincipal: Colors.blue,
                      colorSombra: const Color(0xFF1971C2),
                      onPressed: _irAPractica,
                    ),
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

class _TituloNumeroCard extends StatelessWidget {
  final String texto;

  const _TituloNumeroCard({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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
          texto,
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

class _NumeroImagenCard extends StatelessWidget {
  final NumeroModel numero;

  const _NumeroImagenCard({required this.numero});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              numero.imagen,
              height: 230,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Número ${numero.nombre}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresApp.azulMedio,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              shadows: SombrasApp.blanca,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoTitulo extends StatelessWidget {
  const _VideoTitulo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.movie, color: ColoresApp.azulMedio),
          SizedBox(width: 8),
          Text(
            'Video',
            style: TextStyle(
              color: ColoresApp.azulMedio,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              shadows: SombrasApp.blanca,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final YoutubePlayerController? controller;

  const _VideoCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.90),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const Text(
          'Video no disponible',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColoresApp.azulMedio,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: YoutubePlayer(
          controller: controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: ColoresApp.rojo,
          progressColors: const ProgressBarColors(
            playedColor: ColoresApp.rojo,
            handleColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
