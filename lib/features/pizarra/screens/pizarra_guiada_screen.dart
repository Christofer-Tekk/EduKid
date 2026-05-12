import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';

class PizarraGuiadaScreen extends StatefulWidget {
  const PizarraGuiadaScreen({Key? key}) : super(key: key);

  @override
  State<PizarraGuiadaScreen> createState() => _PizarraGuiadaScreenState();
}

class _PizarraGuiadaScreenState extends State<PizarraGuiadaScreen> {
  final List<Offset?> _puntos = [];
  final GlobalKey _canvasKey = GlobalKey();
  String _letraActual = '';

  final Random _random = Random();
  final String _abecedario = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';

  final Color _colorLetraFondo = Colors.grey.withOpacity(0.28);
  final Color _colorTrazado = ColoresApp.magentaLogo;
  final Color _colorBotonConfirmar = ColoresApp.completado;
  final Color _colorBotonBorrar = ColoresApp.naranjaVibrante;
  final Color _colorBotonVolver = ColoresApp.azulLogo;

  @override
  void initState() {
    super.initState();
    _cambiarLetraAleatoria();
  }

  void _cambiarLetraAleatoria() {
    setState(() {
      _puntos.clear();
      _letraActual = _abecedario[_random.nextInt(_abecedario.length)];
    });
  }

  void _limpiarPizarra() {
    setState(() => _puntos.clear());
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
            '¿Limpiar práctica?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.rojoVibrante,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Se borrará el trazo actual de la letra.',
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
                'Limpiar',
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

  void _agregarPunto(Offset punto, Size size) {
    final estaDentro = Rect.fromLTWH(0, 0, size.width, size.height).contains(punto);

    if (!estaDentro) {
      _cerrarTrazo();
      return;
    }

    setState(() => _puntos.add(punto));
  }

  void _cerrarTrazo() {
    if (_puntos.isNotEmpty && _puntos.last != null) {
      setState(() => _puntos.add(null));
    }
  }

  void _onVerificar() {
    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? const Size(300, 450);
    final cobertura = _calcularCobertura(size);

    if (cobertura >= 0.60) {
      _mostrarDialogoAcierto();
    } else {
      _mostrarDialogoFallo();
    }
  }

  double _calcularCobertura(Size size) {
    final puntosValidos = _puntos.whereType<Offset>().toList();

    if (puntosValidos.length < 35) return 0.0;

    final letraRect = _obtenerRectLetra(size).inflate(22);
    final puntosDentroLetra = puntosValidos.where(letraRect.contains).toList();

    if (puntosDentroLetra.length < 30) return 0.0;

    final proporcionDentro = puntosDentroLetra.length / puntosValidos.length;
    if (proporcionDentro < 0.55) return 0.0;

    final recorrido = _calcularRecorridoTotal(_puntos);
    if (recorrido < min(size.width, size.height) * 0.45) return 0.0;

    final zonas = _crearZonasLetra(letraRect);
    int zonasCubiertas = 0;

    for (final zona in zonas) {
      final puntosEnZona = puntosDentroLetra.where((punto) => zona.contains(punto)).length;
      if (puntosEnZona >= 8) zonasCubiertas++;
    }

    return zonasCubiertas / zonas.length;
  }

  double _calcularRecorridoTotal(List<Offset?> puntos) {
    double total = 0.0;
    Offset? anterior;

    for (final punto in puntos) {
      if (punto == null) {
        anterior = null;
        continue;
      }

      if (anterior != null) {
        total += (punto - anterior).distance;
      }

      anterior = punto;
    }

    return total;
  }

  Rect _obtenerRectLetra(Size size) {
    final fontSize = _calcularFontSize(size);
    final textPainter = TextPainter(
      text: TextSpan(
        text: _letraActual,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);

    final offsetX = (size.width - textPainter.width) / 2;
    final offsetY = (size.height - textPainter.height) / 2;

    return Rect.fromLTWH(offsetX, offsetY, textPainter.width, textPainter.height);
  }

  double _calcularFontSize(Size size) {
    return min(size.width * 0.92, size.height * 0.62);
  }

  List<Rect> _crearZonasLetra(Rect rect) {
    return [
      Rect.fromLTWH(rect.left, rect.top, rect.width / 2, rect.height / 2),
      Rect.fromLTWH(rect.left + rect.width / 2, rect.top, rect.width / 2, rect.height / 2),
      Rect.fromLTWH(rect.left, rect.top + rect.height / 2, rect.width / 2, rect.height / 2),
      Rect.fromLTWH(rect.left + rect.width / 2, rect.top + rect.height / 2, rect.width / 2, rect.height / 2),
      rect.deflate(rect.width * 0.22),
    ];
  }

  void _mostrarDialogoAcierto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text(
            '¡Excelente!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Has trazado la letra muy bien.',
            style: TextStyle(color: Colors.black87, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorBotonVolver,
                shape: const StadiumBorder(),
                elevation: 5,
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _cambiarLetraAleatoria();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoFallo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text(
            'Revisa tu trazo',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Traza encima de la letra gris. Si rayas fuera de la letra, no contará como correcto.',
            style: TextStyle(color: Colors.black87, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorBotonBorrar,
                shape: const StadiumBorder(),
                elevation: 5,
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _limpiarPizarra();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final safeTop = MediaQuery.of(context).padding.top;
          final safeBottom = MediaQuery.of(context).padding.bottom;

          final canvasLeft = width * 0.135;
          final canvasTop = height * 0.255;
          final canvasRight = width * 0.135;
          final canvasBottom = max(height * 0.145, safeBottom + 102.0);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppFondos.pizarra,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: canvasTop,
                left: canvasLeft,
                right: canvasRight,
                bottom: canvasBottom,
                child: ClipRect(
                  child: LayoutBuilder(
                    builder: (context, boardConstraints) {
                      final canvasSize = Size(
                        boardConstraints.maxWidth,
                        boardConstraints.maxHeight,
                      );

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) => _agregarPunto(details.localPosition, canvasSize),
                        onPanUpdate: (details) => _agregarPunto(details.localPosition, canvasSize),
                        onPanEnd: (_) => _cerrarTrazo(),
                        onPanCancel: _cerrarTrazo,
                        child: CustomPaint(
                          key: _canvasKey,
                          painter: _LinePainter(
                            points: _puntos,
                            traceColor: _colorTrazado,
                            letra: _letraActual,
                            letterColor: _colorLetraFondo,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: safeTop + 10,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _EtiquetaSuperior(
                      texto: 'PRACTICA',
                      color: ColoresApp.naranjaVibrante,
                      icono: Icons.edit,
                    ),
                    _BotonSuperior(
                      texto: 'VOLVER',
                      icono: Icons.arrow_back,
                      color: _colorBotonVolver,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: safeBottom + 14,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: _BotonInferior(
                        texto: 'BORRAR',
                        icono: Icons.delete,
                        color: _colorBotonBorrar,
                        onPressed: _confirmarLimpiarPizarra,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _BotonInferior(
                        texto: 'VERIFICAR',
                        icono: Icons.check,
                        color: _colorBotonConfirmar,
                        onPressed: _onVerificar,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EtiquetaSuperior extends StatelessWidget {
  final String texto;
  final Color color;
  final IconData icono;

  const _EtiquetaSuperior({
    required this.texto,
    required this.color,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
      icon: Icon(icono, color: Colors.white, size: 18),
      label: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        elevation: 5,
      ),
    );
  }
}

class _BotonInferior extends StatelessWidget {
  final String texto;
  final IconData icono;
  final Color color;
  final VoidCallback onPressed;

  const _BotonInferior({
    required this.texto,
    required this.icono,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono, color: Colors.white, size: 22),
      label: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 13),
        elevation: 5,
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<Offset?> points;
  final Color traceColor;
  final String letra;
  final Color letterColor;

  _LinePainter({
    required this.points,
    required this.traceColor,
    required this.letra,
    required this.letterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fontSize = min(size.width * 0.92, size.height * 0.62);
    final textPainter = TextPainter(
      text: TextSpan(
        text: letra,
        style: TextStyle(
          color: letterColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    final paint = Paint()
      ..color = traceColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) => true;
}
