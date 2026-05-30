// lib/features/animales/screens/animal_practica_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/home_button.dart';
import '../../../core/widgets/practice_success_dialog.dart';
import '../../../data/local/datos_animales.dart';
import '../../../data/models/animal_model.dart';
import '../../../data/services/progreso_service.dart';

class OpcionJuego {
  final AnimalModel animal;
  String estado;

  OpcionJuego({
    required this.animal,
    this.estado = 'idle',
  });
}

class AnimalPracticaScreen extends StatefulWidget {
  const AnimalPracticaScreen({super.key});

  @override
  State<AnimalPracticaScreen> createState() => _AnimalPracticaScreenState();
}

class _AnimalPracticaScreenState extends State<AnimalPracticaScreen> {
  late AnimalModel animalObjetivo;
  final List<OpcionJuego> opciones = [];

  bool inicializado = false;
  bool _guardando = false;

  final int totalAEncontrar = 3;
  int encontrados = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!inicializado) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is AnimalModel) {
        animalObjetivo = args;
      } else {
        animalObjetivo = listaAnimales.first;
      }

      _generarOpciones();
      inicializado = true;
    }
  }

  void _generarOpciones() {
    final random = Random();

    opciones.clear();
    encontrados = 0;

    for (int i = 0; i < totalAEncontrar; i++) {
      opciones.add(OpcionJuego(animal: animalObjetivo));
    }

    final incorrectos = listaAnimales
        .where((animal) => animal.clave != animalObjetivo.clave)
        .toList()
      ..shuffle(random);

    for (int i = 0; i < 3 && i < incorrectos.length; i++) {
      opciones.add(OpcionJuego(animal: incorrectos[i]));
    }

    opciones.shuffle(random);

    if (mounted) setState(() {});
  }

  Future<void> _verificarRespuesta(int index) async {
    if (_guardando || opciones[index].estado != 'idle') return;

    final opcion = opciones[index];
    final esCorrecto = opcion.animal.clave == animalObjetivo.clave;

    setState(() {
      if (esCorrecto) {
        opcion.estado = 'correcto';
        encontrados++;
      } else {
        opcion.estado = 'incorrecto';
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    if (!esCorrecto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Intenta otra vez. Ese animal no es.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFF6B6B),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final faltan = totalAEncontrar - encontrados;

    if (faltan > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Correcto! Faltan $faltan ${animalObjetivo.nombre.toUpperCase()} más.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF2DC653),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    await _completarPractica();
  }

  Future<void> _completarPractica() async {
    if (_guardando) return;

    setState(() => _guardando = true);

    await ProgresoService.completarAnimal(animalObjetivo.clave);
    animalObjetivo.completado = true;

    if (!mounted) return;

    setState(() => _guardando = false);

    final siguiente = _obtenerSiguienteAnimal();

    await PracticeSuccessDialog.show(
      context: context,
      message: '¡Muy bien! Encontraste todos los ${animalObjetivo.nombre.toLowerCase()}s.',
      primaryText: 'Practicar otra vez',
      secondaryText: siguiente == null ? 'Volver al menú' : 'Siguiente animal',
      onPrimary: () {
        _generarOpciones();
      },
      onSecondary: () {
        if (siguiente == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
          return;
        }

        setState(() {
          animalObjetivo = siguiente;
        });
        _generarOpciones();
      },
    );
  }

  AnimalModel? _obtenerSiguienteAnimal() {
    final index = listaAnimales.indexWhere(
      (animal) => animal.clave == animalObjetivo.clave,
    );

    if (index == -1 || index >= listaAnimales.length - 1) {
      return null;
    }

    return listaAnimales[index + 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppFondos.animales,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTitleChip('PRÁCTICA'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HomeButton.iconOnly(),
                          const SizedBox(width: 10),
                          _buildBackButton(context),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildInstruction(),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: opciones.length,
                    itemBuilder: (context, index) {
                      final opcion = opciones[index];

                      Color borderColor = Colors.white;
                      IconData? icon;
                      Color? iconColor;

                      if (opcion.estado == 'correcto') {
                        borderColor = const Color(0xFF2DC653);
                        icon = Icons.check_circle;
                        iconColor = const Color(0xFF2DC653);
                      } else if (opcion.estado == 'incorrecto') {
                        borderColor = const Color(0xFFFF6B6B);
                        icon = Icons.cancel;
                        iconColor = const Color(0xFFFF6B6B);
                      }

                      return GestureDetector(
                        onTap: () => _verificarRespuesta(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: borderColor, width: 5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Center(
                                  child: Image.asset(
                                    opcion.animal.imagenSf,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              if (icon != null)
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: iconColor,
                                      size: 44,
                                    ),
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

  Widget _buildTitleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD6336C),
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
      label: const Text(
        'VOLVER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF339AF0),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        elevation: 5,
      ),
    );
  }

  Widget _buildInstruction() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF339AF0),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD6336C).withOpacity(0.4),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Image.asset(
              animalObjetivo.imagenSf,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Selecciona todos los\n${animalObjetivo.nombre.toUpperCase()}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1B3B6F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
