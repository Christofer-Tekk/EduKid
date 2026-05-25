import 'package:flutter/material.dart';
import '../../../data/local/datos_numeros.dart';

class NumerosScreen extends StatefulWidget {
  const NumerosScreen({Key? key}) : super(key: key);

  @override
  State<NumerosScreen> createState() => _NumerosScreenState();
}

class _NumerosScreenState extends State<NumerosScreen> {
  final List<Color> _colores = const [
    Color(0xFFFF6B6B), Color(0xFF4ECDC4), Color(0xFFFFD166), 
    Color(0xFF06D6A0), Color(0xFF118AB2), Color(0xFFE5989B), 
    Color(0xFF8338EC), Color(0xFFFF9F1C), Color(0xFF90BE6D),
  ];

  @override
  Widget build(BuildContext context) {
    int completados = listaNumeros.where((n) => n.completado).length;

    return Scaffold(
      body: Stack(
        children: [
          // ¡FONDO CORREGIDO! El de los números pastel
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_numeros.png',
              fit: BoxFit.cover,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // BARRA SUPERIOR (Igual que en Colores y Abecedario)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cápsula Blanca del Título
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                        ),
                        child: const Text(
                          'Números',
                          style: TextStyle(
                            color: Color(0xFFD6336C), // Rojo/Rosado fuerte
                            fontSize: 26, 
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      
                      // Botón VOLVER (Azul)
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF339AF0), // Azul claro
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // CÁPSULA BLANCA DE PROGRESO
                Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
                  ),
                  child: Text(
                    '$completados/20 completadas ⭐',
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF1B3B6F) // Azul oscuro
                    ),
                  ),
                ),
                
                // CUADRÍCULA DE NÚMEROS (Volvimos al tamaño original grande)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, 
                      crossAxisSpacing: 15, 
                      mainAxisSpacing: 15, 
                      childAspectRatio: 0.9,
                    ),
                    itemCount: listaNumeros.length,
                    itemBuilder: (context, index) {
                      final numero = listaNumeros[index];
                      final colorBox = _colores[index % _colores.length];

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.pushNamed(context, '/numero_detalle', arguments: numero);
                          setState(() {}); 
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colorBox,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4)],
                              ),
                              child: Center(
                                child: Text(
                                  numero.valor.toString(),
                                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black38, blurRadius: 2, offset: Offset(1, 1))]),
                                ),
                              ),
                            ),
                            
                            // Estrellita
                            if (numero.completado)
                              Positioned(
                                top: -8,
                                left: -8,
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.star, color: Colors.amber, size: 20),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
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