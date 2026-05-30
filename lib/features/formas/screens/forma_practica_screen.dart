// lib/features/formas/screens/forma_practica_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';
import '../../../core/widgets/practice_success_dialog.dart';
import '../../../data/local/datos_formas.dart';
import '../../../data/models/forma_model.dart';
import '../../../data/services/progreso_service.dart';
import 'formas_screen.dart'; // importa FormaPainter

class FormaPracticaScreen extends StatefulWidget {
  const FormaPracticaScreen({super.key});

  @override
  State<FormaPracticaScreen> createState() => _FormaPracticaScreenState();
}

class _FormaPracticaScreenState extends State<FormaPracticaScreen> {
  late FormaModel _formaObjetivo;
  late List<_FormaOption> _opciones;

  final Set<int> _correctasSeleccionadas = {};
  final Set<int> _incorrectasSeleccionadas = {};

  String? _mensaje;
  bool _respuestaCorrecta = false;
  bool _practicaCompletada = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    _formaObjetivo = args is FormaModel ? args : datosFormas.first;
    _opciones = _generarOpciones();
    _initialized = true;
  }

  List<_FormaOption> _generarOpciones() {
    final random = Random();

    // Colores aleatorios para las formas correctas (misma forma, colores distintos)
    final coloresDisponibles = [
      0xFFE53935, 0xFF1E88E5, 0xFFFFD54F, 0xFF43A047,
      0xFFFF8F00, 0xFF8E24AA, 0xFFEC407A, 0xFF00ACC1,
    ]..shuffle(random);

    // Formas incorrectas (formas distintas a la objetivo)
    final formasIncorrectas = datosFormas
        .where((f) => f.clave != _formaObjetivo.clave)
        .toList()
      ..shuffle(random);

    var id = 0;
    final opciones = <_FormaOption>[
      // 3 opciones correctas: misma forma, colores aleatorios
      for (int i = 0; i < 3; i++)
        _FormaOption(
          id: id++,
          shapeType: _formaObjetivo.shapeType,
          colorHex: coloresDisponibles[i],
          esCorrecto: true,
        ),
      // 3 opciones incorrectas: formas distintas con colores aleatorios
      for (int i = 0; i < 3; i++)
        _FormaOption(
          id: id++,
          shapeType: formasIncorrectas[i].shapeType,
          colorHex: coloresDisponibles[i + 3],
          esCorrecto: false,
        ),
    ];

    opciones.shuffle(random);
    return opciones;
  }

  Future<void> _seleccionarOpcion(_FormaOption opcion) async {
    if (_practicaCompletada) return;

    if (opcion.esCorrecto) {
      if (_correctasSeleccionadas.contains(opcion.id)) return;

      setState(() {
        _correctasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = true;
        final faltan = 3 - _correctasSeleccionadas.length;
        if (faltan > 0) {
          _mensaje = '¡Bien! Te faltan $faltan ${faltan == 1 ? 'figura' : 'figuras'} más.';
        } else {
          _mensaje = '¡Excelente! Encontraste todos los ${_formaObjetivo.nombre}s.';
          _practicaCompletada = true;
        }
      });

      if (_practicaCompletada) {
        await ProgresoService.completarForma(_formaObjetivo.clave);
        if (!mounted) return;
        _mostrarDialogoCorrecto();
      }
    } else {
      setState(() {
        _incorrectasSeleccionadas.add(opcion.id);
        _respuestaCorrecta = false;
        _mensaje = 'Esa no es un ${_formaObjetivo.nombre}. ¡Sigue buscando!';
      });
    }
  }

  FormaModel? _obtenerSiguienteForma() {
    final indexActual = datosFormas.indexWhere(
      (forma) => forma.clave == _formaObjetivo.clave,
    );

    if (indexActual == -1 || indexActual >= datosFormas.length - 1) {
      return null;
    }

    return datosFormas[indexActual + 1];
  }

  void _irASiguienteForma() {
    final siguienteForma = _obtenerSiguienteForma();

    if (siguienteForma == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
      return;
    }

    setState(() {
      _formaObjetivo = siguienteForma;
      _mensaje = null;
      _respuestaCorrecta = false;
      _practicaCompletada = false;
      _correctasSeleccionadas.clear();
      _incorrectasSeleccionadas.clear();
      _opciones = _generarOpciones();
    });
  }

  void _mostrarDialogoCorrecto() {
    final siguienteForma = _obtenerSiguienteForma();

    PracticeSuccessDialog.show(
      context: context,
      message:
          '¡Muy bien! Encontraste todas las figuras con forma de ${_formaObjetivo.nombre}.',
      primaryText: 'Practicar otra vez',
      secondaryText: siguienteForma == null ? 'Volver al menú' : 'Siguiente forma',
      onPrimary: _reiniciar,
      onSecondary: _irASiguienteForma,
    );
  }

  void _reiniciar() {
    setState(() {
      _mensaje = null;
      _respuestaCorrecta = false;
      _practicaCompletada = false;
      _correctasSeleccionadas.clear();
      _incorrectasSeleccionadas.clear();
      _opciones = _generarOpciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.formas,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: _buildTitleCard(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const HomeButton.iconOnly(),
                  const SizedBox(width: 10),
                  BotonAccion(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back_rounded,
                    colorPrincipal: const Color(0xFF339AF0),
                    colorSombra: const Color(0xFF1971C2),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Instrucción
            _buildInstruccionCard(),

            if (_mensaje != null) ...[
              const SizedBox(height: 10),
              _buildMensajeCard(),
            ],

            const SizedBox(height: 10),

            // Grid de opciones
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
                  return _FormaOptionButton(
                    opcion: opcion,
                    selectedCorrect: _correctasSeleccionadas.contains(opcion.id),
                    selectedWrong: _incorrectasSeleccionadas.contains(opcion.id),
                    onTap: () => _seleccionarOpcion(opcion),
                  );
                },
              ),
            ),

            // Botón cambiar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: BotonAccion(
                texto: 'CAMBIAR',
                icono: Icons.refresh_rounded,
                colorPrincipal: ColoresApp.naranjaVibrante,
                colorSombra: ColoresApp.naranja,
                onPressed: _reiniciar,
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
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 9, offset: const Offset(0, 4)),
        ],
      ),
      child: const AppTexto.titulo(
        'Práctica',
        color: Color(0xFF6A1B9A),
        shadows: SombrasApp.blanca,
        fontSize: 26,
      ),
    );
  }

  Widget _buildInstruccionCard() {
    final color = Color(_formaObjetivo.colorHex);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Forma objetivo dibujada
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.4), width: 2),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(42, 42),
                painter: FormaPainter(color: color, shapeType: _formaObjetivo.shapeType),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppTexto.subtitulo(
              'Selecciona todas las figuras\n"${_formaObjetivo.nombre}"',
              color: ColoresApp.azulMedio,
              shadows: SombrasApp.blanca,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensajeCard() {
    final color = _respuestaCorrecta ? ColoresApp.completado : const Color(0xFFE53935);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        _mensaje!,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );
  }
}

class _FormaOption {
  final int id;
  final int shapeType;
  final int colorHex;
  final bool esCorrecto;

  _FormaOption({
    required this.id,
    required this.shapeType,
    required this.colorHex,
    required this.esCorrecto,
  });
}

class _FormaOptionButton extends StatelessWidget {
  final _FormaOption opcion;
  final bool selectedCorrect;
  final bool selectedWrong;
  final VoidCallback onTap;

  const _FormaOptionButton({
    required this.opcion,
    required this.selectedCorrect,
    required this.selectedWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(opcion.colorHex);
    final borderColor = selectedCorrect
        ? ColoresApp.completado
        : selectedWrong
            ? const Color(0xFFE53935)
            : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: borderColor,
                width: selectedCorrect || selectedWrong ? 4 : 3,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 9, offset: const Offset(0, 5)),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(88, 88),
                painter: FormaPainter(color: color, shapeType: opcion.shapeType),
              ),
            ),
          ),
          if (selectedCorrect || selectedWrong)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: selectedCorrect ? ColoresApp.completado : const Color(0xFFE53935),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 6, offset: const Offset(0, 3)),
                  ],
                ),
                child: Icon(
                  selectedCorrect ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}