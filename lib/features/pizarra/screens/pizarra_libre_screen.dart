import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/home_button.dart';

class PizarraLibreScreen extends StatefulWidget {
  const PizarraLibreScreen({Key? key}) : super(key: key);

  @override
  State<PizarraLibreScreen> createState() => _PizarraLibreScreenState();
}

class DrawingPoint {
  final Offset point;
  final Paint paint;

  DrawingPoint({required this.point, required this.paint});
}

class _PizarraLibreScreenState extends State<PizarraLibreScreen> {
  final List<DrawingPoint?> _puntos = [];
  Color _colorActual = Colors.black;
  final double _grosorActual = 8.0;
  bool _modoBorrador = false;
  bool _mostrarPaleta = false;

  final List<Color> _colores = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  Paint _crearPaint() {
    return Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..color = _modoBorrador ? Colors.transparent : _colorActual
      ..strokeWidth = _modoBorrador ? 30.0 : _grosorActual
      ..blendMode = _modoBorrador ? BlendMode.clear : BlendMode.srcOver;
  }

  void _agregarPunto(Offset punto) {
    setState(() {
      _mostrarPaleta = false;
      _puntos.add(DrawingPoint(point: punto, paint: _crearPaint()));
    });
  }

  void _cerrarTrazo() {
    if (_puntos.isNotEmpty && _puntos.last != null) {
      setState(() => _puntos.add(null));
    }
  }

  void _seleccionarColor(Color color) {
    setState(() {
      _colorActual = color;
      _modoBorrador = false;
      _mostrarPaleta = false;
    });
  }

  void _limpiarPizarra() {
    setState(() {
      _puntos.clear();
      _mostrarPaleta = false;
      _modoBorrador = false;
    });
  }

  Future<void> _confirmarLimpiarPizarra() async {
    if (_puntos.isEmpty) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          title: const Text(
            '¿Borrar dibujo?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.rojoVibrante,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Se limpiará toda la pizarra.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: ColoresApp.azulMarino,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.rojoVibrante,
                shape: const StadiumBorder(),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Borrar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmar != true) return;
    _limpiarPizarra();
  }

  Widget _buildLienzo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _agregarPunto(details.localPosition),
          onPanUpdate: (details) => _agregarPunto(details.localPosition),
          onPanEnd: (_) => _cerrarTrazo(),
          onPanCancel: _cerrarTrazo,
          child: CustomPaint(
            painter: _LibrePainter(_puntos),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _buildPaleta() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 10,
        children: _colores.map((color) {
          final seleccionado = _colorActual == color && !_modoBorrador;
          return GestureDetector(
            onTap: () => _seleccionarColor(color),
            child: CircleAvatar(
              backgroundColor: color,
              radius: 20,
              child: seleccionado
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Row(
                children: [
                  _BotonSuperior(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back,
                    color: ColoresApp.azulLogo,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'PIZARRA LIBRE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColoresApp.magentaLogo,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const HomeButton.iconOnly(),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 112),
                      child: _buildLienzo(),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 96,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.12),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _mostrarPaleta
                          ? _buildPaleta()
                          : const SizedBox.shrink(key: ValueKey('sin-paleta')),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 12,
                    child: _BarraHerramientas(
                      modoBorrador: _modoBorrador,
                      mostrarPaleta: _mostrarPaleta,
                      onLapiz: () {
                        setState(() {
                          _modoBorrador = false;
                          _mostrarPaleta = false;
                        });
                      },
                      onPaleta: () {
                        setState(() {
                          _modoBorrador = false;
                          _mostrarPaleta = !_mostrarPaleta;
                        });
                      },
                      onBorrador: () {
                        setState(() {
                          _modoBorrador = true;
                          _mostrarPaleta = false;
                        });
                      },
                      onLimpiar: _confirmarLimpiarPizarra,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonSuperior extends StatelessWidget {
  final String texto;
  final IconData icono;
  final Color color;
  final VoidCallback onPressed;

  const _BotonSuperior({
    required this.texto,
    required this.icono,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono, color: Colors.white, size: 16),
      label: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 4,
      ),
    );
  }
}

class _BarraHerramientas extends StatelessWidget {
  final bool modoBorrador;
  final bool mostrarPaleta;
  final VoidCallback onLapiz;
  final VoidCallback onPaleta;
  final VoidCallback onBorrador;
  final VoidCallback onLimpiar;

  const _BarraHerramientas({
    required this.modoBorrador,
    required this.mostrarPaleta,
    required this.onLapiz,
    required this.onPaleta,
    required this.onBorrador,
    required this.onLimpiar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BotonHerramienta(
            icono: Icons.edit,
            colorFondo: ColoresApp.magentaLogo,
            estaSeleccionado: !modoBorrador && !mostrarPaleta,
            alPresionar: onLapiz,
          ),
          _BotonHerramienta(
            icono: Icons.palette,
            colorFondo: ColoresApp.azulLogo,
            estaSeleccionado: mostrarPaleta,
            alPresionar: onPaleta,
          ),
          _BotonHerramienta(
            icono: Icons.cleaning_services_rounded,
            colorFondo: ColoresApp.naranjaVibrante,
            estaSeleccionado: modoBorrador,
            alPresionar: onBorrador,
          ),
          _BotonHerramienta(
            icono: Icons.delete_forever,
            colorFondo: ColoresApp.rojoVibrante,
            estaSeleccionado: false,
            alPresionar: onLimpiar,
          ),
        ],
      ),
    );
  }
}

class _BotonHerramienta extends StatelessWidget {
  final IconData icono;
  final Color colorFondo;
  final bool estaSeleccionado;
  final VoidCallback alPresionar;

  const _BotonHerramienta({
    required this.icono,
    required this.colorFondo,
    required this.estaSeleccionado,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alPresionar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: estaSeleccionado ? colorFondo : colorFondo.withOpacity(0.62),
          shape: BoxShape.circle,
          border: Border.all(
            color: estaSeleccionado ? Colors.black87 : Colors.white,
            width: estaSeleccionado ? 2.2 : 1.5,
          ),
          boxShadow: estaSeleccionado
              ? const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Icon(icono, color: Colors.white, size: 28),
      ),
    );
  }
}

class _LibrePainter extends CustomPainter {
  final List<DrawingPoint?> points;

  _LibrePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.point, points[i + 1]!.point, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!.point], points[i]!.paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
