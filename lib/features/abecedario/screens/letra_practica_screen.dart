import 'package:flutter/material.dart';

class LetraPracticaScreen extends StatefulWidget {
  final String letra; // La letra que el niño va a practicar (ej. 'A')

  const LetraPracticaScreen({Key? key, required this.letra}) : super(key: key);

  @override
  _LetraPracticaScreenState createState() => _LetraPracticaScreenState();
}

class _LetraPracticaScreenState extends State<LetraPracticaScreen> {
  // Aquí guardamos todos los puntos (coordenadas) por donde pasa el dedo
  List<Offset?> puntos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traza la letra ${widget.letra}'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          // Botón para limpiar la pizarra
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                puntos.clear(); // Borra todos los puntos dibujados
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // 1. La letra de fondo (marca de agua para que el niño se guíe)
          Center(
            child: Text(
              widget.letra,
              style: TextStyle(
                fontSize: 300,
                color: Colors.grey.withOpacity(0.3), // Semi-transparente
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // 2. El detector de toques y el lienzo para dibujar
          GestureDetector(
            // Cuando el dedo toca la pantalla
            onPanStart: (details) {
              setState(() {
                puntos.add(details.localPosition);
              });
            },
            // Cuando el dedo se mueve por la pantalla
            onPanUpdate: (details) {
              setState(() {
                puntos.add(details.localPosition);
              });
            },
            // Cuando el niño levanta el dedo
            onPanEnd: (details) {
              setState(() {
                puntos.add(null); // Un punto nulo significa "corte de línea"
              });
            },
            child: CustomPaint(
              painter: PizarraPainter(puntos: puntos),
              size: Size.infinite, // Ocupa toda la pantalla disponible
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// CLASE PAINTER: Esta es la que se encarga de renderizar la "tinta"
// =====================================================================
class PizarraPainter extends CustomPainter {
  final List<Offset?> puntos;

  PizarraPainter({required this.puntos});

  @override
  void paint(Canvas canvas, Size size) {
    // Configuración del "marcador"
    Paint pintura = Paint()
      ..color = Colors.blue // Color del trazo
      ..strokeCap = StrokeCap.round // Bordes redondeados
      ..strokeWidth = 15.0; // Grosor de la línea (ideal para niños)

    // Dibujamos las líneas conectando los puntos
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i] != null && puntos[i + 1] != null) {
        // Dibuja una línea entre el punto actual y el siguiente
        canvas.drawLine(puntos[i]!, puntos[i + 1]!, pintura);
      }
    }
  }

  @override
  bool shouldRepaint(PizarraPainter oldDelegate) {
    return true; // Se repinta cada vez que agregamos un punto nuevo
  }
}
