import 'package:flutter/material.dart';
import '../../../data/local/datos_numeros.dart';

class NumerosScreen extends StatelessWidget {
  const NumerosScreen({Key? key}) : super(key: key);

  // Paleta de colores divertidos para los cuadros
  final List<Color> _colores = const [
    Color(0xFFFF6B6B), Color(0xFF4ECDC4), Color(0xFFFFD166), 
    Color(0xFF06D6A0), Color(0xFF118AB2), Color(0xFFE5989B), 
    Color(0xFF8338EC), Color(0xFFFF9F1C), Color(0xFF90BE6D),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Un fondo celeste suave infantil
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Números',
          style: TextStyle(
            color: Colors.redAccent, 
            fontSize: 32, 
            fontWeight: FontWeight.w900,
            shadows: [Shadow(color: Colors.white, blurRadius: 3)]
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF339AF0),
              shape: const StadiumBorder(),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '¡Aprende a contar hasta 20!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 columnas como en el abecedario
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: listaNumeros.length,
                itemBuilder: (context, index) {
                  final numero = listaNumeros[index];
                  final colorBox = _colores[index % _colores.length];

                  return GestureDetector(
                    onTap: () {
                      // Pasamos el número seleccionado a la siguiente pantalla
                      Navigator.pushNamed(
                        context, 
                        '/numero_detalle', 
                        arguments: numero,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorBox,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          numero.valor.toString(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black38, blurRadius: 2, offset: Offset(1, 1))],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}