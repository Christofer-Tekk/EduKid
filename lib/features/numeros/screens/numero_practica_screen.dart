import 'package:flutter/material.dart';
import '../../../data/models/numero_model.dart';

class NumeroPracticaScreen extends StatefulWidget {
  const NumeroPracticaScreen({Key? key}) : super(key: key);

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

  // --- LÓGICA DE VERIFICACIÓN (Igual a la de las letras) ---
  void _verificarTrazo() {
    if (_puntos.isEmpty || _puntos.where((p) => p != null).length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Traza el número primero!')));
      return;
    }
    
    // Aquí podrías añadir una validación más compleja, pero por ahora mostramos éxito
    _mostrarDialogoResultado(true);
  }

  void _mostrarDialogoResultado(bool esCorrecto) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(esCorrecto ? '¡Excelente! 🎉' : '¡Inténtalo otra vez! 💪'),
        content: Text(esCorrecto ? '¡Has trazado el número ${_numero.valor} perfectamente!' : 'Asegúrate de seguir la guía.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (esCorrecto) Navigator.pop(context); // Regresa a la pantalla anterior
            },
            child: const Text('Continuar'),
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
          // Fondo
          Positioned.fill(child: Image.asset('assets/images/fondo/fondo_numeros.png', fit: BoxFit.cover)),

          // --- EL CUADRADO BLANCO (Lo que pediste) ---
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Blanco con transparencia
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.blueAccent, width: 3),
              ),
              child: Center(
                child: Text(
                  _numero.valor.toString(),
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400, // Ahora se verá mucho mejor
                  ),
                ),
              ),
            ),
          ),

          // Pizarra de dibujo
          GestureDetector(
            onPanUpdate: (d) => setState(() => _puntos.add((context.findRenderObject() as RenderBox).globalToLocal(d.globalPosition))),
            onPanEnd: (_) => setState(() => _puntos.add(null)),
            child: CustomPaint(
              painter: _PainterNumeros(_puntos, _colorTrazado),
              size: Size.infinite,
            ),
          ),

          // Barra Superior (Botón Volver)
          Positioned(
            top: 40, left: 20,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back), label: const Text('VOLVER'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: const StadiumBorder()),
            ),
          ),

          // Botones inferiores
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _limpiarPizarra,
                  icon: const Icon(Icons.delete), label: const Text('LIMPIAR'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: const StadiumBorder(), padding: const EdgeInsets.all(20)),
                ),
                ElevatedButton.icon(
                  onPressed: _verificarTrazo,
                  icon: const Icon(Icons.check), label: const Text('VERIFICAR'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF51CF66), shape: const StadiumBorder(), padding: const EdgeInsets.all(20)),
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