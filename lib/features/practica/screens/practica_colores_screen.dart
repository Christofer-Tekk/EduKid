// lib/features/practica/screens/practica_colores_screen.dart

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

class PracticaColoresScreen extends StatefulWidget {
  const PracticaColoresScreen({super.key});

  @override
  State<PracticaColoresScreen> createState() => _PracticaColoresScreenState();
}

class _PracticaColoresScreenState extends State<PracticaColoresScreen> {
  final Random _random = Random();
  late ColorModel _colorObjetivo;
  late List<_ColorPracticeOption> _opciones;

  final Set<int> _correctasSeleccionadas = <int>{};
  final Set<int> _incorrectasSeleccionadas = <int>{};
  String? _mensaje;
  bool _respuestaCorrecta = false;
  bool _practicaCompletada = false;

  @override
  void initState() {
    super.initState();
    _cambiarColorAleatorio();
  }

  void _cambiarColorAleatorio() {
    setState(() {
      _colorObjetivo = datosColores[_random.nextInt(datosColores.length)];
      _reiniciarEstado();
      _opciones = _generarOpciones();
    });
  }

  void _reiniciarEstado() {
    _mensaje = null;
    _respuestaCorrecta = false;
    _practicaCompletada = false;
    _correctasSeleccionadas.clear();
    _incorrectasSeleccionadas.clear();
  }

  List<_ColorPracticeOption> _generarOpciones() {
    final formas = List<int>.generate(6, (index) => index)..shuffle(_random);
    final incorrectos = datosColores.where((color) => color.clave != _colorObjetivo.clave).toList()..shuffle(_random);

    var id = 0;
    final opciones = <_ColorPracticeOption>[
      for (int i = 0; i < 3; i++)
        _ColorPracticeOption(
          id: id++,
          colorItem: _colorObjetivo,
          shapeType: formas[i],
          esCorrecto: true,
        ),
      for (int i = 0; i < 3; i++)
        _ColorPracticeOption(
          id: id++,
          colorItem: incorrectos[i],
          shapeType: formas[i + 3],
          esCorrecto: false,
        ),
    ];

    opciones.shuffle(_random);
    return opciones;
  }

  void _seleccionarOpcion(_ColorPracticeOption opcion) {
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
        _mostrarDialogoAcierto();
      }
    } else {
      setState(() {
        _incorrectasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = false;
        _mensaje = 'Ese no es ${_colorObjetivo.nombre}. Busca todas las formas de color ${_colorObjetivo.nombre}.';
      });
    }
  }

  void _mostrarDialogoAcierto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          title: const Text(
            '¡Excelente! ⭐',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.completado,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Encontraste todos los elementos de color ${_colorObjetivo.nombre}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.azulLogo,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 5,
              ),
              onPressed: () {
                Navigator.pop(context);
                _cambiarColorAleatorio();
              },
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.colores,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Row(
                children: [
                  _buildTitleCard(),
                  const Spacer(),
                  const HomeButton.iconOnly(),
                  const SizedBox(width: 8),
                  BotonAccion(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back_rounded,
                    colorPrincipal: ColoresApp.azulLogo,
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    selectedIncorrect: _incorrectasSeleccionadas.contains(opcion.id),
                    onTap: () => _seleccionarOpcion(opcion),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: const AppTexto.titulo(
        'Colores',
        fontSize: 24,
        color: ColoresApp.azulMarino,
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(_colorObjetivo.colorHex), width: 4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.13), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Text(
        'Selecciona todas las formas de color\n${_colorObjetivo.nombreMayuscula}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: ColoresApp.azulMarino,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _respuestaCorrecta ? const Color(0xFFE6FCF5) : const Color(0xFFFFE3E3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _respuestaCorrecta ? ColoresApp.completado : ColoresApp.rojoVibrante,
          width: 2,
        ),
      ),
      child: Text(
        _mensaje!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _respuestaCorrecta ? const Color(0xFF087F5B) : ColoresApp.rojoVibrante,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ColorPracticeOption {
  final int id;
  final ColorModel colorItem;
  final int shapeType;
  final bool esCorrecto;

  const _ColorPracticeOption({
    required this.id,
    required this.colorItem,
    required this.shapeType,
    required this.esCorrecto,
  });
}

class _ShapeOptionButton extends StatelessWidget {
  final _ColorPracticeOption opcion;
  final bool selectedCorrect;
  final bool selectedIncorrect;
  final VoidCallback onTap;

  const _ShapeOptionButton({
    required this.opcion,
    required this.selectedCorrect,
    required this.selectedIncorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selectedCorrect
        ? ColoresApp.completado
        : selectedIncorrect
            ? ColoresApp.rojoVibrante
            : Colors.white;
    final icon = selectedCorrect
        ? Icons.check_circle_rounded
        : selectedIncorrect
            ? Icons.cancel_rounded
            : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: borderColor, width: 5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: CustomPaint(
                size: const Size(88, 88),
                painter: _PracticeShapePainter(
                  color: Color(opcion.colorItem.colorHex),
                  shapeType: opcion.shapeType,
                ),
              ),
            ),
            if (icon != null)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  icon,
                  color: selectedCorrect ? ColoresApp.completado : ColoresApp.rojoVibrante,
                  size: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PracticeShapePainter extends CustomPainter {
  final Color color;
  final int shapeType;

  const _PracticeShapePainter({required this.color, required this.shapeType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final stroke = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..isAntiAlias = true;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.shortestSide / 2;

    switch (shapeType % 6) {
      case 0:
        canvas.drawCircle(center, radius * 0.82, paint);
        canvas.drawCircle(center, radius * 0.82, stroke);
        break;
      case 1:
        final r = Rect.fromCenter(center: center, width: size.width * 0.76, height: size.height * 0.76);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(16)), paint);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(16)), stroke);
        break;
      case 2:
        final path = Path()
          ..moveTo(center.dx, size.height * 0.08)
          ..lineTo(size.width * 0.92, size.height * 0.88)
          ..lineTo(size.width * 0.08, size.height * 0.88)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
        break;
      case 3:
        final r = Rect.fromCenter(center: center, width: size.width * 0.86, height: size.height * 0.55);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(18)), paint);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(18)), stroke);
        break;
      case 4:
        final path = Path();
        for (int i = 0; i < 10; i++) {
          final angle = -pi / 2 + i * pi / 5;
          final currentRadius = i.isEven ? radius * 0.86 : radius * 0.42;
          final point = Offset(center.dx + cos(angle) * currentRadius, center.dy + sin(angle) * currentRadius);
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
        break;
      default:
        final path = Path()
          ..moveTo(center.dx, size.height * 0.08)
          ..lineTo(size.width * 0.92, center.dy)
          ..lineTo(center.dx, size.height * 0.92)
          ..lineTo(size.width * 0.08, center.dy)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _PracticeShapePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.shapeType != shapeType;
}
