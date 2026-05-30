// lib/features/colores/screens/color_practica_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';
import '../../../data/local/datos_colores.dart';
import '../../../data/models/color_model.dart';
import '../../../data/services/progreso_service.dart';

class ColorPracticaScreen extends StatefulWidget {
  const ColorPracticaScreen({super.key});

  @override
  State<ColorPracticaScreen> createState() => _ColorPracticaScreenState();
}

class _ColorPracticaScreenState extends State<ColorPracticaScreen> {
  late ColorModel _colorObjetivo;
  late List<_ColorOption> _opciones;

  final Set<int> _correctasSeleccionadas = <int>{};
  final Set<int> _incorrectasSeleccionadas = <int>{};

  String? _mensaje;
  bool _respuestaCorrecta = false;
  bool _practicaCompletada = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    _colorObjetivo = args is ColorModel ? args : datosColores.first;
    _opciones = _generarOpciones();
    _initialized = true;
  }

  List<_ColorOption> _generarOpciones() {
    final random = Random();
    final formas = List<int>.generate(6, (index) => index)..shuffle(random);

    final incorrectos = datosColores
        .where((color) => color.clave != _colorObjetivo.clave)
        .toList()
      ..shuffle(random);

    var id = 0;
    final opciones = <_ColorOption>[
      for (int i = 0; i < 3; i++)
        _ColorOption(
          id: id++,
          colorItem: _colorObjetivo,
          shapeType: formas[i],
          esCorrecto: true,
        ),
      for (int i = 0; i < 3; i++)
        _ColorOption(
          id: id++,
          colorItem: incorrectos[i],
          shapeType: formas[i + 3],
          esCorrecto: false,
        ),
    ];

    opciones.shuffle(random);
    return opciones;
  }

  Future<void> _seleccionarOpcion(_ColorOption opcion) async {
    if (_practicaCompletada) return;

    if (opcion.esCorrecto) {
      if (_correctasSeleccionadas.contains(opcion.id)) return;

      setState(() {
        _correctasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = true;

        final faltan = 3 - _correctasSeleccionadas.length;
        if (faltan > 0) {
          _mensaje = '¡Bien! Te faltan $faltan forma${faltan == 1 ? '' : 's'} de color ${_colorObjetivo.nombre}.';
        } else {
          _mensaje = '¡Excelente! Encontraste todas las formas de color ${_colorObjetivo.nombre}.';
          _practicaCompletada = true;
        }
      });

      if (_practicaCompletada) {
        await ProgresoService.completarColor(_colorObjetivo.clave);
        if (!mounted) return;
        _mostrarDialogoCorrecto();
      }
    } else {
      setState(() {
        _incorrectasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = false;
        _mensaje = 'Ese no es ${_colorObjetivo.nombre}. Busca las formas de color ${_colorObjetivo.nombre}.';
      });
    }
  }

  void _mostrarDialogoCorrecto() {
    final currentIndex = datosColores.indexWhere(
      (color) => color.clave == _colorObjetivo.clave,
    );
    final hasNext = currentIndex >= 0 && currentIndex < datosColores.length - 1;
    final nextColor = hasNext ? datosColores[currentIndex + 1] : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: const Text(
            '¡Excelente! ⭐',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.completado,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          content: Text(
            'Encontraste todas las formas de color ${_colorObjetivo.nombre}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresApp.azulMedio,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          actions: [
            Wrap(
              spacing: 12,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _reiniciarOpciones();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.naranjaVibrante,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Practicar otra vez',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    if (hasNext && nextColor != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/color_practica',
                        arguments: nextColor,
                      );
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339AF0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    hasNext ? 'Siguiente color' : 'Volver al menú',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _reiniciarOpciones() {
    setState(() {
      _mensaje = null;
      _respuestaCorrecta = false;
      _practicaCompletada = false;
      _correctasSeleccionadas.clear();
      _incorrectasSeleccionadas.clear();
      _opciones = _generarOpciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.colores,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  Expanded(child: _buildTitleCard()),
                  const SizedBox(width: 8),
                  const HomeButton.iconOnly(),
                  const SizedBox(width: 8),
                  BotonAccion(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back_rounded,
                    colorPrincipal: const Color(0xFF339AF0),
                    colorSombra: const Color(0xFF1971C2),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            _buildInstructionCard(),

            if (_mensaje != null) ...[
              const SizedBox(height: 10),
              _buildMessageCard(),
            ],

            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
                itemCount: _opciones.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final opcion = _opciones[index];
                  return _ShapeOptionButton(
                    opcion: opcion,
                    selectedCorrect: _correctasSeleccionadas.contains(opcion.id),
                    selectedWrong: _incorrectasSeleccionadas.contains(opcion.id),
                    onTap: () => _seleccionarOpcion(opcion),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: BotonAccion(
                texto: 'CAMBIAR',
                icono: Icons.refresh_rounded,
                colorPrincipal: ColoresApp.naranjaVibrante,
                colorSombra: ColoresApp.naranja,
                onPressed: _reiniciarOpciones,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AppTexto.titulo(
          'Práctica',
          color: ColoresApp.rojo,
          shadows: SombrasApp.blanca,
          fontSize: 28,
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    final targetColor = Color(_colorObjetivo.colorHex);
    final isWhite = _colorObjetivo.clave == 'blanco';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
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
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: targetColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isWhite ? Colors.black38 : Colors.white,
                width: isWhite ? 3 : 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: targetColor.withOpacity(isWhite ? 0.20 : 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppTexto.subtitulo(
              'Selecciona todas las formas de color "${_colorObjetivo.nombre}"',
              color: ColoresApp.azulMedio,
              shadows: SombrasApp.blanca,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    final color = _respuestaCorrecta
        ? ColoresApp.completado
        : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        _mensaje!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _ColorOption {
  final int id;
  final ColorModel colorItem;
  final int shapeType;
  final bool esCorrecto;

  _ColorOption({
    required this.id,
    required this.colorItem,
    required this.shapeType,
    required this.esCorrecto,
  });
}

class _ShapeOptionButton extends StatelessWidget {
  final _ColorOption opcion;
  final bool selectedCorrect;
  final bool selectedWrong;
  final VoidCallback onTap;

  const _ShapeOptionButton({
    required this.opcion,
    required this.selectedCorrect,
    required this.selectedWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(opcion.colorItem.colorHex);
    final isWhite = opcion.colorItem.clave == 'blanco';
    final borderColor = selectedCorrect
        ? ColoresApp.completado
        : selectedWrong
            ? const Color(0xFFE53935)
            : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: borderColor, width: selectedCorrect || selectedWrong ? 4 : 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 9,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(92, 92),
                painter: _ShapePainter(
                  color: color,
                  shapeType: opcion.shapeType,
                  needsDarkBorder: isWhite,
                ),
              ),
            ),
          ),
          if (selectedCorrect || selectedWrong)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: selectedCorrect ? ColoresApp.completado : const Color(0xFFE53935),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  selectedCorrect ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final Color color;
  final int shapeType;
  final bool needsDarkBorder;

  _ShapePainter({
    required this.color,
    required this.shapeType,
    required this.needsDarkBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = needsDarkBorder ? Colors.black45 : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = needsDarkBorder ? 3 : 4
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.74,
      height: size.height * 0.74,
    );

    Path path;

    switch (shapeType) {
      case 0:
        canvas.drawCircle(center, size.width * 0.34, fillPaint);
        canvas.drawCircle(center, size.width * 0.34, borderPaint);
        return;
      case 1:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(16)),
          fillPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(16)),
          borderPaint,
        );
        return;
      case 2:
        path = Path()
          ..moveTo(center.dx, size.height * 0.13)
          ..lineTo(size.width * 0.86, size.height * 0.82)
          ..lineTo(size.width * 0.14, size.height * 0.82)
          ..close();
        break;
      case 3:
        path = Path()
          ..moveTo(center.dx, size.height * 0.08)
          ..lineTo(size.width * 0.87, center.dy)
          ..lineTo(center.dx, size.height * 0.92)
          ..lineTo(size.width * 0.13, center.dy)
          ..close();
        break;
      case 4:
        path = _starPath(center, size.width * 0.38, size.width * 0.18);
        break;
      default:
        path = Path()
          ..moveTo(center.dx, size.height * 0.10)
          ..cubicTo(size.width * 0.95, size.height * 0.20, size.width * 0.86,
              size.height * 0.68, center.dx, size.height * 0.90)
          ..cubicTo(size.width * 0.14, size.height * 0.68, size.width * 0.05,
              size.height * 0.20, center.dx, size.height * 0.10)
          ..close();
        break;
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  Path _starPath(Offset center, double outerRadius, double innerRadius) {
    final path = Path();
    const points = 5;
    const startAngle = -pi / 2;
    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = startAngle + i * pi / points;
      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.shapeType != shapeType ||
        oldDelegate.needsDarkBorder != needsDarkBorder;
  }
}
