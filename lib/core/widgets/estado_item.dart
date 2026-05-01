// lib/core/widgets/estado_item.dart
// Botón de letra/número con indicador de estado y estrella mejorada

import 'package:flutter/material.dart';

class EstadoItem extends StatefulWidget {
  final String texto;
  final Color color;
  final String estado; // "no_iniciado", "en_progreso", "completado"
  final VoidCallback onTap;

  const EstadoItem({
    Key? key,
    required this.texto,
    required this.color,
    required this.estado,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EstadoItem> createState() => _EstadoItemState();
}

class _EstadoItemState extends State<EstadoItem> {
  bool _presionado = false;

  // Color más oscuro para efecto 3D
  Color get _colorSombra {
    final hsl = HSLColor.fromColor(widget.color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _presionado = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Botón principal con efecto 3D
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            margin: EdgeInsets.only(
              top: _presionado ? 5 : 0,
              bottom: _presionado ? 0 : 5,
            ),
            decoration: BoxDecoration(
              color: _colorSombra, // base oscura (sombra 3D)
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  widget.texto,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    // Amarillo dorado para máxima visibilidad
                    color: const Color(0xFFFFD166),
                    shadows: const [
                      // Sombra oscura gruesa para contraste
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 0,
                        offset: Offset(1.5, 1.5),
                      ),
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Estrella cuando está completado
          if (widget.estado == 'completado')
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),

          // Punto amarillo cuando está en progreso
          if (widget.estado == 'en_progreso')
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}