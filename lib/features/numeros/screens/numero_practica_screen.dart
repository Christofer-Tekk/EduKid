import 'package:flutter/material.dart';
import '../../../data/models/numero_model.dart';

class NumeroPracticaScreen extends StatefulWidget {
  NumeroPracticaScreen({Key? key}) : super(key: key);

  @override
  State<NumeroPracticaScreen> createState() => _NumeroPracticaScreenState();
}

class _NumeroPracticaScreenState extends State<NumeroPracticaScreen> {
  List<Offset?> _puntos = [];
  late NumeroModel _numero;
  final Color _colorTrazado = const Color(0xFFFF6B9D);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _numero = ModalRoute.of(context)!.settings.arguments as NumeroModel;
  }

  void _limpiarPizarra() => setState(() => _puntos.clear());

  void _verificarTrazo() {
    // Validación: si no dibujó casi nada, falla. Si dibujó suficiente, es éxito.
    if (_puntos.isEmpty || _puntos.where((p) => p != null).length < 20) {
      _mostrarDialogoFallo();
    } else {
      _mostrarDialogoExito();
    }
  }

  void _mostrarDialogoFallo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Inténtalo de nuevo! 💪', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Asegúrate de trazar justo encima del número gris', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(context);
              _limpiarPizarra();
            },
            child: const Text('Intentar otra vez', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoExito() {
    // ¡AQUÍ SE GUARDA EL PROGRESO!
    setState(() {
      _numero.completado = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Excelente! ⭐', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('¡Has completado este número!\nSe guardó tu progreso.', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF51CF66), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pop(context); // Regresa a la pantalla de detalle
            },
            child: const Text('¡Listo! 🎉', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/fondo/fondo_numeros.png', fit: BoxFit.cover)),
          
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Center(
                child: Text(
                  _numero.valor.toString(),
                  style: TextStyle(fontSize: 250, fontWeight: FontWeight.bold, color: Colors.grey.shade300),
                ),
              ),
            ),
          ),

          GestureDetector(
            onPanUpdate: (d) => setState(() => _puntos.add((context.findRenderObject() as RenderBox).globalToLocal(d.globalPosition))),
            onPanEnd: (_) => setState(() => _puntos.add(null)),
            child: CustomPaint(painter: _PainterNumeros(_puntos, _colorTrazado), size: Size.infinite),
          ),

          Positioned(
            top: 40, left: 20,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16), 
              label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF339AF0), shape: const StadiumBorder()),
            ),
          ),

          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _limpiarPizarra,
                  icon: const Icon(Icons.refresh, color: Colors.white), label: const Text('LIMPIAR', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                ),
                ElevatedButton.icon(
                  onPressed: _verificarTrazo,
                  icon: const Icon(Icons.check, color: Colors.white), label: const Text('VERIFICAR', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF51CF66), shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PainterNumeros extends CustomPainter {
  final List<Offset?> puntos;
  final Color color;
  _PainterNumeros(this.puntos, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()..color = color..strokeWidth = 20.0..strokeCap = StrokeCap.round;
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i] != null && puntos[i + 1] != null) canvas.drawLine(puntos[i]!, puntos[i + 1]!, p);
    }
  }
  @override bool shouldRepaint(_) => true;
}