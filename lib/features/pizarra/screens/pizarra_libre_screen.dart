import 'package:flutter/material.dart';

// Modelo para guardar cada punto con su color y su grosor (para el borrador)
class PuntoColorido {
  final Offset? punto;
  final Color color;
  final double grosor;

  PuntoColorido({required this.punto, required this.color, required this.grosor});
}

class PizarraLibreScreen extends StatefulWidget {
  const PizarraLibreScreen({super.key});

  @override
  State<PizarraLibreScreen> createState() => _PizarraLibreScreenState();
}

class _PizarraLibreScreenState extends State<PizarraLibreScreen> {
  List<PuntoColorido> puntos = [];
  
  // Variables de estado para las herramientas
  Color colorActivo = Colors.black; // Color por defecto del lápiz
  double grosorActivo = 8.0; // Grosor normal del lápiz
  bool esBorrador = false;
  bool mostrarPaleta = false;

  final List<Color> listaColores = [
    Colors.black, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // Flecha y texto en negro
        title: const Text(
          'Pizarra',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/pizarra_guiada');
            },
            icon: const Icon(Icons.school, color: Colors.blue),
            label: const Text(
              "Practicar", 
              style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)
              ),
          )
        ],
      ),
      body: Column(
        children: [
          // ZONA DE DIBUJO
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  puntos.add(PuntoColorido(
                    punto: details.localPosition,
                    color: esBorrador ? Colors.white : colorActivo,
                    grosor: esBorrador ? 30.0 : grosorActivo, // El borrador es más grueso
                  ));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  puntos.add(PuntoColorido(
                    punto: null,
                    color: esBorrador ? Colors.white : colorActivo,
                    grosor: esBorrador ? 30.0 : grosorActivo,
                  ));
                });
              },
              child: CustomPaint(
                painter: PizarraLibrePainter(puntos: puntos),
                size: Size.infinite,
              ),
            ),
          ),

          // ZONA DE LA PALETA DE COLORES (Aparece y desaparece)
          if (mostrarPaleta)
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: listaColores.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        colorActivo = color;
                        esBorrador = false; // Si elige color, deja de borrar
                        mostrarPaleta = false; // Oculta la paleta al elegir
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorActivo == color && !esBorrador ? Colors.grey : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // BARRA DE HERRAMIENTAS (Abajo)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Botón Lápiz
                _construirBotonHerramienta(
                  icono: Icons.edit,
                  estaActivo: !esBorrador && !mostrarPaleta,
                  alPresionar: () {
                    setState(() {
                      esBorrador = false;
                      mostrarPaleta = false;
                    });
                  },
                ),
                // 2. Botón Paleta
                _construirBotonHerramienta(
                  icono: Icons.palette,
                  estaActivo: mostrarPaleta,
                  alPresionar: () {
                    setState(() {
                      mostrarPaleta = !mostrarPaleta;
                      esBorrador = false;
                    });
                  },
                ),
                // 3. Botón Borrador
                _construirBotonHerramienta(
                  icono: Icons.cleaning_services_rounded, // Ícono similar a borrador
                  estaActivo: esBorrador,
                  alPresionar: () {
                    setState(() {
                      esBorrador = true;
                      mostrarPaleta = false;
                    });
                  },
                ),
                // 4. Botón Basura
                _construirBotonHerramienta(
                  icono: Icons.delete_outline,
                  estaActivo: false,
                  alPresionar: () {
                    setState(() {
                      puntos.clear(); // Limpia toda la pantalla
                      mostrarPaleta = false;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Diseño de tus botones cuadraditos cyan (como en tu dibujo)
  Widget _construirBotonHerramienta({required IconData icono, required bool estaActivo, required VoidCallback alPresionar}) {
    return GestureDetector(
      onTap: alPresionar,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.cyanAccent, // El color celeste/cyan de tu dibujo
          border: Border.all(
            color: estaActivo ? Colors.black : Colors.black54,
            width: estaActivo ? 3.0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(8), // Cuadrado con bordes un poquito redondeados
        ),
        child: Icon(
          icono,
          size: 35,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PizarraLibrePainter extends CustomPainter {
  final List<PuntoColorido> puntos;

  PizarraLibrePainter({required this.puntos});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i].punto != null && puntos[i + 1].punto != null) {
        Paint pintura = Paint()
          ..color = puntos[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = puntos[i].grosor;

        canvas.drawLine(puntos[i].punto!, puntos[i + 1].punto!, pintura);
      }
    }
  }

  @override
  bool shouldRepaint(PizarraLibrePainter oldDelegate) => true;
}