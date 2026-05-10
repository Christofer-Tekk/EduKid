import 'package:flutter/material.dart';
import 'dart:ui'; 

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
  // --- ESTADO DE LA PIZARRA ---
  List<DrawingPoint?> _puntos = [];
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. EL FONDO DE PIZARRA TOTAL
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_pizarra.png',
              fit: BoxFit.fill,
            ),
          ),

          // 2. LIENZO DE DIBUJO LIBRE
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _mostrarPaleta = false; 
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                _puntos.add(
                  DrawingPoint(
                    point: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = StrokeCap.round
                      ..isAntiAlias = true
                      ..color = _modoBorrador ? Colors.transparent : _colorActual
                      ..strokeWidth = _modoBorrador ? 30.0 : _grosorActual 
                      ..blendMode = _modoBorrador ? BlendMode.clear : BlendMode.srcOver,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                _puntos.add(
                  DrawingPoint(
                    point: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = StrokeCap.round
                      ..isAntiAlias = true
                      ..color = _modoBorrador ? Colors.transparent : _colorActual
                      ..strokeWidth = _modoBorrador ? 30.0 : _grosorActual
                      ..blendMode = _modoBorrador ? BlendMode.clear : BlendMode.srcOver,
                  ),
                );
              });
            },
            onPanEnd: (details) {
              setState(() {
                _puntos.add(null); 
              });
            },
            child: CustomPaint(
              painter: _LibrePainter(_puntos),
              size: Size.infinite,
            ),
          ),

          // 3. BARRA SUPERIOR PERSONALIZADA (Corregida: Sin Overflow y Sin Congelamiento)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 5, 
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón "VOLVER"
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                  label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339AF0),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                
                // Título Decorado "PIZARRA"
                const Expanded(
                  child: Center(
                    child: Text(
                      'PIZARRA',
                      style: TextStyle(
                        color: Color(0xFFD6336C), 
                        fontSize: 20, 
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(color: Colors.white, blurRadius: 0, offset: Offset(2, 2)),
                          Shadow(color: Colors.white, blurRadius: 10)
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Botón "PRACTICAR" 
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/pizarra_guiada'),
                  icon: const Icon(Icons.school, color: Colors.white, size: 16),
                  label: const Text('PRACTICA', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF51CF66),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ),

          // 4. MINI-PALETA DE COLORES
          if (_mostrarPaleta)
            Positioned(
              bottom: 90,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 15,
                  runSpacing: 10,
                  children: _colores.map((c) => GestureDetector(
                    onTap: () => _seleccionarColor(c),
                    child: CircleAvatar(
                      backgroundColor: c,
                      radius: 20,
                      child: _colorActual == c && !_modoBorrador
                          ? const Icon(Icons.check, color: Colors.white, size: 24)
                          : null,
                    ),
                  )).toList(),
                ),
              ),
            ),

          // 5. BARRA DE HERRAMIENTAS INFERIOR
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BotonHerramienta(
                    icono: Icons.edit,
                    colorFondo: const Color(0xFFFF6B9D),
                    estaSeleccionado: !_modoBorrador && !_mostrarPaleta,
                    alPresionar: () {
                      setState(() {
                        _modoBorrador = false;
                        _mostrarPaleta = false;
                      });
                    },
                  ),
                  _BotonHerramienta(
                    icono: Icons.palette,
                    colorFondo: const Color(0xFF339AF0),
                    estaSeleccionado: _mostrarPaleta,
                    alPresionar: () {
                      setState(() {
                        _mostrarPaleta = !_mostrarPaleta;
                      });
                    },
                  ),
                  _BotonHerramienta(
                    icono: Icons.cleaning_services_rounded,
                    colorFondo: Colors.orange,
                    estaSeleccionado: _modoBorrador,
                    alPresionar: () {
                      setState(() {
                        _modoBorrador = true;
                        _mostrarPaleta = false;
                      });
                    },
                  ),
                  _BotonHerramienta(
                    icono: Icons.delete_forever,
                    colorFondo: const Color(0xFFD6336C),
                    estaSeleccionado: false, 
                    alPresionar: _limpiarPizarra,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- COMPONENTES VISUALES ---

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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: estaSeleccionado ? colorFondo : colorFondo.withOpacity(0.5),
          shape: BoxShape.circle,
          border: estaSeleccionado ? Border.all(color: Colors.black87, width: 2) : null,
          boxShadow: estaSeleccionado ? const [BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3))] : null,
        ),
        child: Icon(icono, color: Colors.white, size: 30),
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