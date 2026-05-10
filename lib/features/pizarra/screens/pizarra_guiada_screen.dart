import 'package:flutter/material.dart';

class PuntoColorido {
  final Offset? punto;
  final Color color;
  PuntoColorido({required this.punto, required this.color});
}

class PizarraGuiadaScreen extends StatefulWidget {
  const PizarraGuiadaScreen({super.key});

  @override
  State<PizarraGuiadaScreen> createState() => _PizarraGuiadaScreenState();
}

class _PizarraGuiadaScreenState extends State<PizarraGuiadaScreen> {
  List<PuntoColorido> puntos = [];
  Color colorSeleccionado = Colors.blue;
  
  final List<String> abecedarioBase = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];
  
  List<String> letrasRestantes = [];
  String letraActual = '';

  final List<Color> colores = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.black
  ];

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    letrasRestantes = List.from(abecedarioBase);
    letrasRestantes.shuffle();
    _siguienteLetra();
  }

  void _siguienteLetra() {
    setState(() {
      if (letrasRestantes.isEmpty) {
        _iniciarJuego(); // Reinicia si se acaban
      } else {
        letraActual = letrasRestantes.removeLast();
        puntos.clear();
      }
    });
  }

  // --- NUEVA LÓGICA DE VERIFICACIÓN ---
  void _verificarTrazo() {
    // 1. Filtramos los puntos reales (ignoramos los saltos del dedo)
    final puntosReales = puntos.where((p) => p.punto != null).map((p) => p.punto!).toList();

    // 2. Si no dibujó casi nada
    if (puntosReales.length < 20) {
      _mostrarMensaje("✏️ Dibuja un poco más para poder verificar.", Colors.orange);
      return;
    }

    // 3. Calculamos el área que ocupa el dibujo (para ver si no es solo un puntito)
    double minX = puntosReales.first.dx;
    double maxX = puntosReales.first.dx;
    double minY = puntosReales.first.dy;
    double maxY = puntosReales.first.dy;

    for (var p in puntosReales) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    double anchoDibujo = maxX - minX;
    double altoDibujo = maxY - minY;

    // 4. Condición: Un trazo normal de letra ocupa al menos unos 60x60 píxeles de área
    if (anchoDibujo > 60 && altoDibujo > 60) {
      _mostrarMensaje("🌟 ¡Excelente! Has trazado la letra muy bien.", Colors.green);
    } else {
      _mostrarMensaje("🤔 Mmm... parece muy pequeño. ¡Sigue las líneas de la letra!", Colors.redAccent);
    }
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating, // Hace que se vea como una burbuja flotante
      )
    );
  }
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text('Traza la letra $letraActual', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          // Botón BORRAR
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            tooltip: 'Borrar dibujo',
            onPressed: () => setState(() => puntos.clear()),
          ),
          // NUEVO: Botón VERIFICAR
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
            tooltip: 'Verificar trazo',
            onPressed: _verificarTrazo,
          ),
          // Botón SIGUIENTE
          TextButton.icon(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            label: const Text("Siguiente", style: TextStyle(fontSize: 14)),
            onPressed: _siguienteLetra,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  puntos.add(PuntoColorido(punto: details.localPosition, color: colorSeleccionado));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  puntos.add(PuntoColorido(punto: null, color: colorSeleccionado));
                });
              },
              child: CustomPaint(
                foregroundPainter: PizarraGuiadaPainter(puntos: puntos),
                size: Size.infinite,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Opacity(
                      opacity: 0.3, 
                      child: Image.asset(
                        // Apuntamos a la carpeta abecedario y en minúsculas como acordamos
                        'assets/images/abecedario/${letraActual.toLowerCase()}.png',
                        fit: BoxFit.contain,
                      ),
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
                  onTap: () => setState(() => colorSeleccionado = color),
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

class PizarraGuiadaPainter extends CustomPainter {
  final List<PuntoColorido> puntos;
  PizarraGuiadaPainter({required this.puntos});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i].punto != null && puntos[i + 1].punto != null) {
        Paint pintura = Paint()
          ..color = puntos[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 25.0;

        canvas.drawLine(puntos[i].punto!, puntos[i + 1].punto!, pintura);
      }
    }
  }
  @override
  bool shouldRepaint(PizarraGuiadaPainter oldDelegate) => true;
}