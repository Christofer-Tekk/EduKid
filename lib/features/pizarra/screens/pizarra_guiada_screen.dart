import 'package:flutter/material.dart';
import 'dart:math';

class PizarraGuiadaScreen extends StatefulWidget {
  const PizarraGuiadaScreen({Key? key}) : super(key: key);

  @override
  State<PizarraGuiadaScreen> createState() => _PizarraGuiadaScreenState();
}

class _PizarraGuiadaScreenState extends State<PizarraGuiadaScreen> {
  // --- ESTADO ---
  List<Offset?> _puntos = [];
  String _letraActual = '';
  final Random _random = Random();
  final String _abecedario = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ";
  
  // Colores unificados 
  final Color _colorLetraFondo = Colors.grey.withOpacity(0.3); 
  final Color _colorTrazado = const Color(0xFFFF6B9D); 
  final Color _colorBotonConfirmar = const Color(0xFF51CF66); 
  final Color _colorBotonBorrar = Colors.orange; 
  final Color _colorBotonVolver = const Color(0xFF339AF0); 

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
    setState(() {
      _puntos.clear();
    });
  }

  // --- LÓGICA DE VALIDACIÓN ---
  void _onVerificar() {
    double cobertura = _calcularCobertura();
    const double umbralDificultad = 0.25;

    if (cobertura >= umbralDificultad) {
      _mostarDialogoAcierto();
    } else {
      _mostrarDialogoFallo();
    }
  }

  double _calcularCobertura() {
    if (_puntos.isEmpty || _puntos.where((p) => p != null).length < 20) return 0.0;

    final trazosValidos = _puntos.where((p) => p != null).toList();
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;

    for (var punto in trazosValidos) {
      minX = min(minX, punto!.dx);
      maxX = max(maxX, punto.dx);
      minY = min(minY, punto.dy);
      maxY = max(maxY, punto.dy);
    }

    final pizarraRect = Rect.fromLTRB(minX, minY, maxX, maxY);
    final anchoPizarra = pizarraRect.width;
    final altoPizarra = pizarraRect.height;

    final anchoZona = anchoPizarra * 0.35;
    final altoZona = altoPizarra * 0.35;

    final zonas = [
      Rect.fromLTWH(pizarraRect.left, pizarraRect.top, anchoZona, altoZona),
      Rect.fromLTWH(pizarraRect.right - anchoZona, pizarraRect.top, anchoZona, altoZona),
      Rect.fromLTWH(pizarraRect.left, pizarraRect.bottom - altoZona, anchoZona, altoZona),
      Rect.fromLTWH(pizarraRect.right - anchoZona, pizarraRect.bottom - altoZona, anchoZona, altoZona),
      Rect.fromCenter(center: pizarraRect.center, width: anchoPizarra * 0.40, height: altoPizarra * 0.40),
    ];

    int zonasCubiertas = 0;
    const int puntosMinimosPorZona = 15;

    for (var zona in zonas) {
      int puntosEnZona = 0;
      for (var punto in trazosValidos) {
        if (zona.contains(punto!)) {
          puntosEnZona++;
        }
      }
      if (puntosEnZona >= puntosMinimosPorZona) {
        zonasCubiertas++;
      }
    }

    return zonasCubiertas / zonas.length;
  }

  // --- DIÁLOGOS ---
  void _mostarDialogoAcierto() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
          backgroundColor: Colors.white,
          title: const Text('¡Excelente! 🎉', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center,),
          content: const Text('Has trazado la letra muy bien.', style: TextStyle(color: Colors.black87, fontSize: 18), textAlign: TextAlign.center,),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorBotonVolver,
                shape: const StadiumBorder(),
                elevation: 5,
              ),
              child: const Text('Continuar →', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
          title: const Text('Revisa tu trazo 💪', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center,),
          content: const Text('Asegúrate de cubrir toda la letra con el dedo para verificar.', style: TextStyle(color: Colors.black87, fontSize: 16), textAlign: TextAlign.center,),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorBotonBorrar,
                shape: const StadiumBorder(),
                elevation: 5,
              ),
              child: const Text('Reintentar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  // --- WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 0. EL FONDO DE PIZARRA TOTAL 
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_pizarra.png',
              fit: BoxFit.fill,
            ),
          ),

          // 1. La Letra de Guía 
          Center(
            child: Text(
              _letraActual,
              style: TextStyle(
                fontSize: 350, 
                fontWeight: FontWeight.bold,
                color: _colorLetraFondo, 
              ),
            ),
          ),
          
          // 2. El Lienzo de Dibujo
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox object = context.findRenderObject() as RenderBox;
                _puntos.add(object.globalToLocal(details.globalPosition));
              });
            },
            onPanEnd: (details) {
              _puntos.add(null); 
            },
            child: CustomPaint(
              painter: _LinePainter(_puntos, _colorTrazado),
              size: Size.infinite,
            ),
          ),
          
          // 3. BARRA SUPERIOR PERSONALIZADA 
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, 
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón "PRACTICA" 
                ElevatedButton(
                  onPressed: () {}, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, 
                    shape: const StadiumBorder(),
                    elevation: 5,
                  ),
                  child: const Text('PRACTICA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                
                // Botón "VOLVER" 
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                  label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorBotonVolver, 
                    shape: const StadiumBorder(),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),

          // 4. Los Botones Inferiores
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _limpiarPizarra,
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('BORRAR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorBotonBorrar,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    elevation: 5,
                  ),
                ),
                
                ElevatedButton.icon(
                  onPressed: _onVerificar,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('VERIFICAR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorBotonConfirmar,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<Offset?> points;
  final Color traceColor;

  _LinePainter(this.points, this.traceColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = traceColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0 
      ..isAntiAlias = true;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}