// lib/features/numeros/screens/numero_practica_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/practice_success_dialog.dart';
import '../../../data/models/numero_model.dart';
import '../../../data/services/progreso_service.dart';

class NumeroPracticaScreen extends StatefulWidget {
  const NumeroPracticaScreen({super.key});

  @override
  State<NumeroPracticaScreen> createState() => _NumeroPracticaScreenState();
}

class _NumeroPracticaScreenState extends State<NumeroPracticaScreen> {
  final GlobalKey<_PizarraNumeroState> _pizarraKey =
      GlobalKey<_PizarraNumeroState>();

  late NumeroModel numero;
  bool _inicializado = false;
  bool _completado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inicializado) return;

    numero = ModalRoute.of(context)!.settings.arguments as NumeroModel;
    _completado = numero.completado;
    _inicializado = true;
  }

  void _limpiarPizarra() {
    _pizarraKey.currentState?.limpiar();
  }

  Future<void> _verificarTrazo() async {
    final cobertura = _pizarraKey.currentState?.calcularCobertura() ?? 0;

    if (cobertura >= 0.15) {
      final yaEstabaCompletado = numero.completado || _completado;

      if (!yaEstabaCompletado) {
        await ProgresoService.completarNumero(numero.valor);
      }

      setState(() {
        numero.completado = true;
        _completado = true;
      });

      _mostrarDialogoExito(yaEstabaCompletado: yaEstabaCompletado);
    } else {
      _mostrarDialogoFallo();
    }
  }

  void _mostrarDialogoFallo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          '¡Inténtalo de nuevo! 💪',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Traza el número ${numero.valor} siguiendo la guía gris.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColoresApp.naranjaVibrante,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _limpiarPizarra();
            },
            child: const Text(
              'Intentar otra vez',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoExito({required bool yaEstabaCompletado}) {
    PracticeSuccessDialog.show(
      context: context,
      message: yaEstabaCompletado
          ? '¡Muy bien! Puedes seguir practicando el número ${numero.valor}.'
          : '¡Completaste el número ${numero.valor}! Ya quedó marcado en tu progreso.',
      primaryText: 'Practicar otra vez',
      secondaryText: 'Volver',
      onPrimary: _limpiarPizarra,
      onSecondary: () => Navigator.pop(context, true),
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
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TituloPracticaCard(texto: 'Práctica'),
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
            _InstruccionCard(numero: numero.valor),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _PizarraNumero(
                      key: _pizarraKey,
                      numero: numero.valor.toString(),
                      completado: _completado,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: BotonAccion(
                        texto: 'LIMPIAR',
                        icono: Icons.refresh,
                        colorPrincipal: ColoresApp.naranjaVibrante,
                        colorSombra: const Color(0xFFE67700),
                        onPressed: () => _limpiarPizarra(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BotonAccion(
                        texto: 'VERIFICAR',
                        icono: Icons.check_box,
                        colorPrincipal: ColoresApp.completado,
                        colorSombra: const Color(0xFF2B8A3E),
                        onPressed: () {
                          _verificarTrazo();
                        },
                      ),
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

class _TituloPracticaCard extends StatelessWidget {
  final String texto;

  const _TituloPracticaCard({required this.texto});

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
      child: Text(
        texto,
        style: const TextStyle(
          color: ColoresApp.rojo,
          fontSize: 27,
          fontWeight: FontWeight.w900,
          shadows: SombrasApp.blanca,
        ),
      ),
    );
  }
}

class _InstruccionCard extends StatelessWidget {
  final int numero;

  const _InstruccionCard({required this.numero});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        'Traza el número $numero',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: ColoresApp.azulMedio,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          shadows: SombrasApp.blanca,
        ),
      ),
    );
  }
}

class _PizarraNumero extends StatefulWidget {
  final String numero;
  final bool completado;

  const _PizarraNumero({
    super.key,
    required this.numero,
    required this.completado,
  });

  @override
  State<_PizarraNumero> createState() => _PizarraNumeroState();
}

class _PizarraNumeroState extends State<_PizarraNumero> {
  final List<List<Offset>> _trazos = [];
  List<Offset> _trazoActual = [];

  static const double _pizarraSize = 300.0;

  double get _fontSize => widget.numero.length >= 2 ? 175.0 : 220.0;

  void limpiar() {
    setState(() {
      _trazos.clear();
      _trazoActual = [];
    });
  }

  double calcularCobertura() {
    final puntos = _todosLosPuntos();

    if (puntos.length < 25) return 0;

    final recorrido = _calcularRecorrido();

    if (recorrido < 90) return 0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.numero,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: _pizarraSize);

    final offsetX = (_pizarraSize - textPainter.width) / 2;
    final offsetY = (_pizarraSize - textPainter.height) / 2;
    final letraRect = Rect.fromLTWH(
      offsetX,
      offsetY,
      textPainter.width,
      textPainter.height,
    );

    final zonas = [
      Rect.fromLTWH(
        letraRect.left,
        letraRect.top,
        letraRect.width / 2,
        letraRect.height / 2,
      ),
      Rect.fromLTWH(
        letraRect.left + letraRect.width / 2,
        letraRect.top,
        letraRect.width / 2,
        letraRect.height / 2,
      ),
      Rect.fromLTWH(
        letraRect.left,
        letraRect.top + letraRect.height / 2,
        letraRect.width / 2,
        letraRect.height / 2,
      ),
      Rect.fromLTWH(
        letraRect.left + letraRect.width / 2,
        letraRect.top + letraRect.height / 2,
        letraRect.width / 2,
        letraRect.height / 2,
      ),
      letraRect.deflate(
        min(letraRect.width, letraRect.height) * 0.20,
      ),
    ];

    var zonasCubiertas = 0;

    for (final zona in zonas) {
      var puntosEnZona = 0;

      for (final punto in puntos) {
        if (zona.inflate(18).contains(punto)) {
          puntosEnZona++;
        }
      }

      if (puntosEnZona >= 8) {
        zonasCubiertas++;
      }
    }

    return zonasCubiertas >= 3 ? 1.0 : 0.0;
  }

  List<Offset> _todosLosPuntos() {
    final puntos = <Offset>[..._trazoActual];

    for (final trazo in _trazos) {
      puntos.addAll(trazo);
    }

    return puntos;
  }

  double _calcularRecorrido() {
    var distancia = 0.0;

    for (final trazo in _trazos) {
      for (var i = 0; i < trazo.length - 1; i++) {
        distancia += (trazo[i] - trazo[i + 1]).distance;
      }
    }

    for (var i = 0; i < _trazoActual.length - 1; i++) {
      distancia += (_trazoActual[i] - _trazoActual[i + 1]).distance;
    }

    return distancia;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _pizarraSize,
      height: _pizarraSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.completado ? ColoresApp.completado : Colors.black26,
          width: widget.completado ? 3 : 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _trazoActual = [details.localPosition];
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _trazoActual = [..._trazoActual, details.localPosition];
            });
          },
          onPanEnd: (_) {
            setState(() {
              if (_trazoActual.isNotEmpty) {
                _trazos.add(List.from(_trazoActual));
              }

              _trazoActual = [];
            });
          },
          child: CustomPaint(
            painter: _PizarraNumeroPainter(
              numero: widget.numero,
              trazos: _trazos,
              trazoActual: _trazoActual,
              completado: widget.completado,
              fontSize: _fontSize,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _PizarraNumeroPainter extends CustomPainter {
  final String numero;
  final List<List<Offset>> trazos;
  final List<Offset> trazoActual;
  final bool completado;
  final double fontSize;

  const _PizarraNumeroPainter({
    required this.numero,
    required this.trazos,
    required this.trazoActual,
    required this.completado,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: numero,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade300,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);

    final paintTrazo = Paint()
      ..color = ColoresApp.magentaLogo
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final trazo in trazos) {
      _dibujarTrazo(canvas, paintTrazo, trazo);
    }

    _dibujarTrazo(canvas, paintTrazo, trazoActual);
  }

  void _dibujarTrazo(Canvas canvas, Paint paint, List<Offset> puntos) {
    if (puntos.length < 2) return;

    final path = Path()..moveTo(puntos.first.dx, puntos.first.dy);

    for (var i = 1; i < puntos.length; i++) {
      path.lineTo(puntos[i].dx, puntos[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PizarraNumeroPainter oldDelegate) {
    return oldDelegate.trazos != trazos ||
        oldDelegate.trazoActual != trazoActual ||
        oldDelegate.numero != numero ||
        oldDelegate.completado != completado;
  }
}
