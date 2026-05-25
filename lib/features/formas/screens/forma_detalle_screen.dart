// lib/features/formas/screens/forma_detalle_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../data/local/datos_formas.dart';
import '../../../data/models/forma_model.dart';
import '../../../data/services/audio_service.dart';

class FormaDetalleScreen extends StatelessWidget {
  const FormaDetalleScreen({super.key});

  FormaModel _getForma(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is FormaModel) return args;
    return datosFormas.first;
  }

  @override
  Widget build(BuildContext context) {
    final formaItem = _getForma(context);
    final color = Color(formaItem.colorHex);

    return BackgroundWrapper(
      assetPath: AppFondos.formas,
      child: SizedBox.expand(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTitleCapsule(formaItem, color),
                    const Spacer(),
                    BotonAccion(
                      texto: 'VOLVER',
                      icono: Icons.arrow_back_rounded,
                      colorPrincipal: const Color(0xFF339AF0),
                      colorSombra: const Color(0xFF1971C2),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                _buildImageAndShape(formaItem, color),

                const SizedBox(height: 18),

                BotonAccion(
                  texto: 'ESCUCHAR',
                  icono: Icons.volume_up_rounded,
                  colorPrincipal: ColoresApp.completado,
                  colorSombra: const Color(0xFF2F9E44),
                  onPressed: () =>
                      AudioService.reproducirAudio(formaItem.rutaAudio),
                ),

                const SizedBox(height: 18),

                BotonAccion(
                  texto: 'PRACTICAR',
                  icono: Icons.school_rounded,
                  colorPrincipal: const Color(0xFF339AF0),
                  colorSombra: const Color(0xFF1971C2),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/forma_practica',
                      arguments: formaItem,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCapsule(FormaModel formaItem, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppTexto.titulo(
        formaItem.nombre,
        color: color,
        shadows: SombrasApp.blanca,
        fontSize: 31,
      ),
    );
  }

  Widget _buildImageAndShape(FormaModel formaItem, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Imagen principal de la forma
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              formaItem.rutaImagen,
              height: 210,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.shape_line_rounded,
                    color: color,
                    size: 100,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Nombre de la forma
          AppTexto.subtitulo(
            formaItem.nombre,
            color: color,
            shadows: SombrasApp.blanca,
            fontSize: 28,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          AppTexto.subtitulo(
            'Es una ${formaItem.nombre}',
            color: ColoresApp.azulMedio,
            shadows: SombrasApp.blanca,
            fontSize: 18,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
