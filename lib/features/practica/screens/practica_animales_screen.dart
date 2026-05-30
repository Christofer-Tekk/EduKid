// lib/features/practica/screens/practica_animales_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';
import '../../../data/local/datos_animales.dart';
import '../../../data/models/animal_model.dart';

class PracticaAnimalesScreen extends StatefulWidget {
  const PracticaAnimalesScreen({super.key});

  @override
  State<PracticaAnimalesScreen> createState() => _PracticaAnimalesScreenState();
}

class _PracticaAnimalesScreenState extends State<PracticaAnimalesScreen> {
  final Random _random = Random();
  late AnimalModel _animalObjetivo;
  late List<_AnimalPracticeOption> _opciones;

  final Set<int> _correctasSeleccionadas = <int>{};
  final Set<int> _incorrectasSeleccionadas = <int>{};
  String? _mensaje;
  bool _respuestaCorrecta = false;
  bool _practicaCompletada = false;

  @override
  void initState() {
    super.initState();
    _cambiarAnimalAleatorio();
  }

  void _cambiarAnimalAleatorio() {
    setState(() {
      _animalObjetivo = listaAnimales[_random.nextInt(listaAnimales.length)];
      _reiniciarEstado();
      _opciones = _generarOpciones();
    });
  }

  void _reiniciarEstado() {
    _mensaje = null;
    _respuestaCorrecta = false;
    _practicaCompletada = false;
    _correctasSeleccionadas.clear();
    _incorrectasSeleccionadas.clear();
  }

  List<_AnimalPracticeOption> _generarOpciones() {
    final incorrectos = listaAnimales.where((animal) => animal.nombre != _animalObjetivo.nombre).toList()..shuffle(_random);

    var id = 0;
    final opciones = <_AnimalPracticeOption>[
      for (int i = 0; i < 3; i++)
        _AnimalPracticeOption(
          id: id++,
          animal: _animalObjetivo,
          esCorrecto: true,
        ),
      for (int i = 0; i < 3; i++)
        _AnimalPracticeOption(
          id: id++,
          animal: incorrectos[i],
          esCorrecto: false,
        ),
    ];

    opciones.shuffle(_random);
    return opciones;
  }

  void _seleccionarOpcion(_AnimalPracticeOption opcion) {
    if (_practicaCompletada) return;

    if (opcion.esCorrecto) {
      if (_correctasSeleccionadas.contains(opcion.id)) return;

      setState(() {
        _correctasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = true;

        final faltan = 3 - _correctasSeleccionadas.length;
        if (faltan > 0) {
          _mensaje = '¡Bien! Te faltan $faltan ${_animalObjetivo.nombre}${faltan == 1 ? '' : 's'}.';
        } else {
          _mensaje = '¡Excelente! Encontraste todos los ${_animalObjetivo.nombre}s.';
          _practicaCompletada = true;
        }
      });

      if (_practicaCompletada) {
        _mostrarDialogoAcierto();
      }
    } else {
      setState(() {
        _incorrectasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = false;
        _mensaje = 'Ese no es ${_animalObjetivo.nombre}. Busca todos los ${_animalObjetivo.nombre}s.';
      });
    }
  }

  void _mostrarDialogoAcierto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          title: const Text(
            '¡Excelente! ⭐',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.completado,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Encontraste todos los ${_animalObjetivo.nombre}s.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.azulLogo,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 5,
              ),
              onPressed: () {
                Navigator.pop(context);
                _cambiarAnimalAleatorio();
              },
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.animales,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Row(
                children: [
                  _buildTitleCard(),
                  const Spacer(),
                  const HomeButton.iconOnly(),
                  const SizedBox(width: 8),
                  BotonAccion(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back_rounded,
                    colorPrincipal: ColoresApp.azulLogo,
                    colorSombra: const Color(0xFF1971C2),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildInstructionCard(),
            if (_mensaje != null) ...[
              const SizedBox(height: 10),
              _buildMessageCard(),
            ],
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
                itemCount: _opciones.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final opcion = _opciones[index];
                  return _AnimalOptionButton(
                    opcion: opcion,
                    selectedCorrect: _correctasSeleccionadas.contains(opcion.id),
                    selectedIncorrect: _incorrectasSeleccionadas.contains(opcion.id),
                    onTap: () => _seleccionarOpcion(opcion),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: const AppTexto.titulo(
        'Animales',
        fontSize: 24,
        color: ColoresApp.azulMarino,
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColoresApp.completado, width: 4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.13), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Text(
        'Selecciona todos los\n${_animalObjetivo.nombre.toUpperCase()}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: ColoresApp.azulMarino,
          fontSize: 23,
          fontWeight: FontWeight.w900,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _respuestaCorrecta ? const Color(0xFFE6FCF5) : const Color(0xFFFFE3E3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _respuestaCorrecta ? ColoresApp.completado : ColoresApp.rojoVibrante,
          width: 2,
        ),
      ),
      child: Text(
        _mensaje!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _respuestaCorrecta ? const Color(0xFF087F5B) : ColoresApp.rojoVibrante,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AnimalPracticeOption {
  final int id;
  final AnimalModel animal;
  final bool esCorrecto;

  const _AnimalPracticeOption({
    required this.id,
    required this.animal,
    required this.esCorrecto,
  });
}

class _AnimalOptionButton extends StatelessWidget {
  final _AnimalPracticeOption opcion;
  final bool selectedCorrect;
  final bool selectedIncorrect;
  final VoidCallback onTap;

  const _AnimalOptionButton({
    required this.opcion,
    required this.selectedCorrect,
    required this.selectedIncorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selectedCorrect
        ? ColoresApp.completado
        : selectedIncorrect
            ? ColoresApp.rojoVibrante
            : Colors.white;
    final icon = selectedCorrect
        ? Icons.check_circle_rounded
        : selectedIncorrect
            ? Icons.cancel_rounded
            : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: borderColor, width: 5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  opcion.animal.imagenSf,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (icon != null)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  icon,
                  color: selectedCorrect ? ColoresApp.completado : ColoresApp.rojoVibrante,
                  size: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
