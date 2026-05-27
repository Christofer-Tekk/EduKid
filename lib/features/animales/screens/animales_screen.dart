import 'package:flutter/material.dart';
import '../../../data/local/datos_animales.dart';

class AnimalesScreen extends StatefulWidget {
  const AnimalesScreen({Key? key}) : super(key: key);

  @override
  State<AnimalesScreen> createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  final List<Color> _cardColors = const [
    Color(0xFF8338EC), Color(0xFFFFB703), Color(0xFFFB5607),
    Color(0xFF06D6A0), Color(0xFFFF006E), Color(0xFF3A86FF),
  ];

  @override
  Widget build(BuildContext context) {
    int completados = listaAnimales.where((a) => a.completado).length;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo temático de Animales
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_animales.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Cabecera unificada con cápsulas blancas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                        ),
                        child: const Text(
                          'Animales',
                          style: TextStyle(color: Color(0xFFD6336C), fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF339AF0),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Contador de progreso dinámico
                Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
                  ),
                  child: Text(
                    '$completados/10 completados ⭐',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B3B6F)),
                  ),
                ),
                // Cuadrícula de tarjetas
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: listaAnimales.length,
                    itemBuilder: (context, index) {
                      final animal = listaAnimales[index];
                      final colorCard = _cardColors[index % _cardColors.length];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/animal_detalle', arguments: animal).then((_) => setState(() {}));
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colorCard,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5)],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        // ¡CAMBIO AQUÍ! Ahora usa la imagen sin fondo (imagenSf)
                                        child: Image.asset(animal.imagenSf, fit: BoxFit.contain),
                                      ),
                                    ),
                                    Text(
                                      animal.nombre,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black38, blurRadius: 2, offset: Offset(1, 1))]),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                            if (animal.completado)
                              Positioned(
                                top: -5,
                                left: -5,
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(Icons.star, color: Colors.amber, size: 22),
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