// lib/features/colores/screens/color_detalle_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../data/local/datos_colores.dart';
import '../../../data/models/color_model.dart';
import '../../../data/services/audio_service.dart';

class ColorDetalleScreen extends StatelessWidget {
  const ColorDetalleScreen({super.key});

  ColorModel _getColor(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ColorModel) return args;
    return datosColores.first;
  }

  @override
  Widget build(BuildContext context) {
    final colorItem = _getColor(context);
    final color = Color(colorItem.colorHex);
    final isWhite = colorItem.clave == 'blanco';

    return BackgroundWrapper(
      assetPath: AppFondos.colores,
      child: SizedBox.expand(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTitleCapsule(colorItem, color, isWhite),
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

                _buildImageAndCircle(colorItem, color, isWhite),

                const SizedBox(height: 18),

                BotonAccion(
                  texto: 'ESCUCHAR',
                  icono: Icons.volume_up_rounded,
                  colorPrincipal: ColoresApp.completado,
                  colorSombra: const Color(0xFF2F9E44),
                  onPressed: () =>
                      AudioService.reproducirAudio(colorItem.rutaAudio),
                ),

                const SizedBox(height: 18),

                BotonAccion(
                  texto: 'PRACTICAR',
                  icono: Icons.school_rounded,
                  colorPrincipal: const Color(0xFF339AF0),
                  colorSombra: const Color(0xFF1971C2),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La práctica de colores estará disponible próximamente.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
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

  Widget _buildTitleCapsule(ColorModel colorItem, Color color, bool isWhite) {
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
        colorItem.nombre,
        color: isWhite ? ColoresApp.azulMedio : color,
        shadows: SombrasApp.blanca,
        fontSize: 31,
      ),
    );
  }

  Widget _buildImageAndCircle(ColorModel colorItem, Color color, bool isWhite) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              colorItem.rutaImagen,
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
                  child: AppTexto.subtitulo(
                    'Imagen no encontrada',
                    color: ColoresApp.azulMedio,
                    shadows: SombrasApp.ninguna,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isWhite ? Colors.black38 : Colors.white,
                width: isWhite ? 3 : 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isWhite ? 0.22 : 0.38),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppTexto.subtitulo(
            'Color ${colorItem.nombre}',
            color: ColoresApp.azulMedio,
            shadows: SombrasApp.blanca,
            fontSize: 22,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
