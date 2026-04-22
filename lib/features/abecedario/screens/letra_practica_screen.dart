import 'package:flutter/material.dart';

// 1. Creamos una clase para guardar cada punto con su propio color
class PuntoColorido {
  final Offset? punto;
  final Color color;
  PuntoColorido({required this.punto, required this.color});
}

class LetraPracticaScreen extends StatefulWidget {
  final String letra;
  const LetraPracticaScreen({Key? key, required this.letra}) : super(key: key);

  @override
  State<LetraPracticaScreen> createState() => _LetraPracticaScreenState();
}

class _LetraPracticaScreenState extends State<LetraPracticaScreen> {
  // 2. Ahora nuestra lista guarda PuntosColoridos en lugar de solo coordenadas
  List<PuntoColorido> puntos = [];
  Color colorSeleccionado = Colors.blue; 

  final List<Color> colores = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traza la letra ${widget.letra}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                puntos.clear();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // SOLUCIÓN AL DESFASE: Usamos localPosition en lugar de globalToLocal
                  puntos.add(PuntoColorido(
                    punto: details.localPosition, 
                    color: colorSeleccionado,
                  ));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  puntos.add(PuntoColorido(
                    punto: null, 
                    color: colorSeleccionado,
                  ));
                });
              },
              child: CustomPaint(
                painter: PizarraPainter(puntos: puntos),
                size: Size.infinite,
                child: Center(
                  child: Text(
                    widget.letra,
                    style: TextStyle(
                      fontSize: 300,
                      color: Colors.grey.withOpacity(0.2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colores.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      colorSeleccionado = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorSeleccionado == color ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class PizarraPainter extends CustomPainter {
  final List<PuntoColorido> puntos;

  PizarraPainter({required this.puntos});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i].punto != null && puntos[i + 1].punto != null) {
        // SOLUCIÓN AL COLOR: Cada línea crea su propia pintura basada en el color guardado
        Paint pintura = Paint()
          ..color = puntos[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 15.0;

        canvas.drawLine(puntos[i].punto!, puntos[i + 1].punto!, pintura);
      }
    }
  }

  @override
  bool shouldRepaint(PizarraPainter oldDelegate) => true;
}