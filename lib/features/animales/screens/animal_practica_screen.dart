import 'package:flutter/material.dart';
import 'dart:math';
import '../../../data/models/animal_model.dart';
import '../../../data/local/datos_animales.dart';

// Clase auxiliar para controlar si cada cuadradito fue tocado y si fue correcto o no
class OpcionJuego {
  final AnimalModel animal;
  String estado; // Puede ser: 'idle' (normal), 'correcto', o 'incorrecto'

  OpcionJuego({required this.animal, this.estado = 'idle'});
}

class AnimalPracticaScreen extends StatefulWidget {
  const AnimalPracticaScreen({Key? key}) : super(key: key);

  @override
  State<AnimalPracticaScreen> createState() => _AnimalPracticaScreenState();
}

class _AnimalPracticaScreenState extends State<AnimalPracticaScreen> {
  late AnimalModel animalObjetivo;
  List<OpcionJuego> opciones = [];
  bool inicializado = false;
  
  final int totalAEncontrar = 3; // ¿Cuántos animales iguales debe buscar?
  int encontrados = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!inicializado) {
      animalObjetivo = ModalRoute.of(context)!.settings.arguments as AnimalModel;
      _generarOpciones();
      inicializado = true;
    }
  }

  void _generarOpciones() {
    final random = Random();
    opciones.clear();
    encontrados = 0;

    // 1. Agregamos 3 animales correctos
    for (int i = 0; i < totalAEncontrar; i++) {
      opciones.add(OpcionJuego(animal: animalObjetivo));
    }

    // 2. Buscamos 3 animales diferentes para despistar
    List<AnimalModel> incorrectos = listaAnimales.where((a) => a.nombre != animalObjetivo.nombre).toList();
    incorrectos.shuffle(random);
    
    for (int i = 0; i < 3; i++) {
      opciones.add(OpcionJuego(animal: incorrectos[i]));
    }

    // 3. Mezclamos las 6 tarjetas para que sea aleatorio
    opciones.shuffle(random);
    setState(() {});
  }

  void _verificarRespuesta(int index) {
    // Si ya lo tocó antes, no hace nada
    if (opciones[index].estado != 'idle') return;

    setState(() {
      if (opciones[index].animal.nombre == animalObjetivo.nombre) {
        // RESPUESTA CORRECTA
        opciones[index].estado = 'correcto';
        encontrados++;
        int faltan = totalAEncontrar - encontrados;

        ScaffoldMessenger.of(context).clearSnackBars(); // Oculta el mensaje anterior rápido
        
        if (faltan > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Correcto! Faltan $faltan ${animalObjetivo.nombre.toUpperCase()} más', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          // JUEGO COMPLETADO
          animalObjetivo.completado = true; // Gana su estrella
          _mostrarDialogoVictoria();
        }
      } else {
        // RESPUESTA INCORRECTA
        opciones[index].estado = 'incorrecto';
      }
    });
  }

  void _mostrarDialogoVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false, // Obliga al niño a presionar un botón
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            '¡Excelente! 🎉', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Color(0xFFD6336C), fontSize: 26, fontWeight: FontWeight.w900),
          ),
          content: Text(
            'Has encontrado todos los\n${animalObjetivo.nombre.toUpperCase()}', 
            textAlign: TextAlign.center, 
            style: const TextStyle(fontSize: 18, color: Color(0xFF1B3B6F), fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra la ventanita
                    _generarOpciones(); // Mezcla y reinicia el juego
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339AF0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('PRACTICAR OTRA VEZ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra la ventanita
                    Navigator.pop(context); // Vuelve a la pantalla de detalle
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B), // Rojo suave
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('VOLVER', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_animales.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // BARRA SUPERIOR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                        ),
                        child: const Text(
                          'PRÁCTICA',
                          style: TextStyle(color: Color(0xFFD6336C), fontSize: 24, fontWeight: FontWeight.w900),
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

                // INSTRUCCIÓN
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF339AF0), width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                  ),
                  child: Text(
                    'Selecciona todos los:\n${animalObjetivo.nombre.toUpperCase()}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1B3B6F)),
                    textAlign: TextAlign.center,
                  ),
                ),

                // CUADRÍCULA DEL JUEGO (Igual a Formas)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columnas
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.0, // Cuadraditos perfectos
                    ),
                    itemCount: opciones.length,
                    itemBuilder: (context, index) {
                      final opcion = opciones[index];
                      
                      // Lógica de colores según el estado
                      Color borderColor = Colors.white;
                      IconData? icon;
                      Color? iconColor;

                      if (opcion.estado == 'correcto') {
                        borderColor = Colors.green;
                        icon = Icons.check_circle;
                        iconColor = Colors.green;
                      } else if (opcion.estado == 'incorrecto') {
                        borderColor = Colors.red;
                        icon = Icons.cancel;
                        iconColor = Colors.red;
                      }

                      return GestureDetector(
                        onTap: () => _verificarRespuesta(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 5), // Borde dinámico
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
                          ),
                          child: Stack(
                            children: [
                              // Imagen del animal (centrada)
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Image.asset(opcion.animal.imagenSf, fit: BoxFit.contain),
                                ),
                              ),
                              // Ícono de Check o X en la esquina superior derecha
                              if (icon != null)
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, color: iconColor, size: 45),
                                  ),
                                ),
                            ],
                          ),
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