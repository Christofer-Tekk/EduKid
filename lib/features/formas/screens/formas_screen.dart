// lib/features/formas/screens/formas_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../data/models/forma_model.dart';
import '../controllers/formas_controller.dart';

class FormasScreen extends StatefulWidget {
  const FormasScreen({super.key});

  @override
  State<FormasScreen> createState() => _FormasScreenState();
}

class _FormasScreenState extends State<FormasScreen> {
  late final FormasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FormasController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.formas,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                  child: Row(
                    children: [
                      _buildTitleCard(),
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
                ),
                _buildProgressCard(),
                const SizedBox(height: 8),
                Expanded(
                  child: _controller.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
                          itemCount: _controller.formas.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 18,
                            childAspectRatio: 0.92,
                          ),
                          itemBuilder: (context, index) {
                            final forma = _controller.formas[index];
                            return _FormaButton(
                              formaItem: forma,
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/forma_detalle',
                                  arguments: forma,
                                );
                                await _controller.cargarFormas();
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 9, offset: const Offset(0, 4)),
        ],
      ),
      child: const AppTexto.titulo(
        'Formas',
        color: Color(0xFF6A1B9A),
        shadows: SombrasApp.blanca,
        fontSize: 30,
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: AppTexto.subtitulo(
        '${_controller.completados}/${_controller.formas.length} completados ⭐',
        textAlign: TextAlign.center,
        color: ColoresApp.azulMedio,
        shadows: SombrasApp.blanca,
        fontSize: 18,
      ),
    );
  }
}

class _FormaButton extends StatelessWidget {
  final FormaModel formaItem;
  final VoidCallback onTap;

  const _FormaButton({required this.formaItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(formaItem.colorHex);
    final completed = formaItem.estado == 'completado';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Botón con la forma dibujada
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 7)),
                      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 9, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(72, 72),
                      painter: FormaPainter(
                        color: color,
                        shapeType: formaItem.shapeType,
                      ),
                    ),
                  ),
                ),
                // Estrella si completado
                if (completed)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: ColoresApp.estrella,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.24), blurRadius: 6, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: const Icon(Icons.star, color: Colors.white, size: 18),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                formaItem.nombreMayuscula,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  shadows: const [Shadow(color: Colors.white, blurRadius: 5)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Painter compartido para todas las formas
class FormaPainter extends CustomPainter {
  final Color color;
  final int shapeType;

  FormaPainter({required this.color, required this.shapeType});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final border = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    Path? path;

    switch (shapeType) {
      case 0: // Círculo
        canvas.drawCircle(Offset(cx, cy), size.width * 0.38, fill);
        canvas.drawCircle(Offset(cx, cy), size.width * 0.38, border);
        return;

      case 1: // Cuadrado
        final r = Rect.fromCenter(center: Offset(cx, cy), width: size.width * 0.72, height: size.height * 0.72);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(6)), fill);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(6)), border);
        return;

      case 2: // Triángulo
        path = Path()
          ..moveTo(cx, size.height * 0.10)
          ..lineTo(size.width * 0.88, size.height * 0.86)
          ..lineTo(size.width * 0.12, size.height * 0.86)
          ..close();
        break;

      case 3: // Rectángulo
        final r = Rect.fromCenter(center: Offset(cx, cy), width: size.width * 0.86, height: size.height * 0.52);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(6)), fill);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(6)), border);
        return;

      case 4: // Estrella
        path = _starPath(Offset(cx, cy), size.width * 0.40, size.width * 0.18);
        break;

      case 5: // Óvalo
        final oval = Rect.fromCenter(center: Offset(cx, cy), width: size.width * 0.86, height: size.height * 0.58);
        canvas.drawOval(oval, fill);
        canvas.drawOval(oval, border);
        return;

      case 6: // Rombo
        path = Path()
          ..moveTo(cx, size.height * 0.08)
          ..lineTo(size.width * 0.90, cy)
          ..lineTo(cx, size.height * 0.92)
          ..lineTo(size.width * 0.10, cy)
          ..close();
        break;

      case 7: // Hexágono
        path = _regularPolygon(Offset(cx, cy), size.width * 0.40, 6, -pi / 2);
        break;

      case 8: // Octágono
        path = _regularPolygon(Offset(cx, cy), size.width * 0.40, 8, -pi / 8);
        break;

      case 9: // Trapecio
        path = Path()
          ..moveTo(size.width * 0.18, size.height * 0.78)
          ..lineTo(size.width * 0.82, size.height * 0.78)
          ..lineTo(size.width * 0.68, size.height * 0.22)
          ..lineTo(size.width * 0.32, size.height * 0.22)
          ..close();
        break;

      default:
        canvas.drawCircle(Offset(cx, cy), size.width * 0.38, fill);
        return;
    }

    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  Path _starPath(Offset center, double outer, double inner) {
    final path = Path();
    const pts = 5;
    const start = -pi / 2;
    for (int i = 0; i < pts * 2; i++) {
      final r = i.isEven ? outer : inner;
      final angle = start + i * pi / pts;
      final p = Offset(center.dx + cos(angle) * r, center.dy + sin(angle) * r);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  Path _regularPolygon(Offset center, double radius, int sides, double startAngle) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = startAngle + (2 * pi * i / sides);
      final p = Offset(center.dx + cos(angle) * radius, center.dy + sin(angle) * radius);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant FormaPainter old) =>
      old.color != color || old.shapeType != shapeType;
}
