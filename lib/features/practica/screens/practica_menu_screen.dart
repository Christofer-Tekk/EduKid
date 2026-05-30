// lib/features/practica/screens/practica_menu_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/boton_modulo.dart';
import '../../../core/widgets/home_button.dart';

class PracticaMenuScreen extends StatelessWidget {
  const PracticaMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.home,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BotonAccion(
                    texto: 'VOLVER',
                    icono: Icons.arrow_back_rounded,
                    colorPrincipal: const Color(0xFF339AF0),
                    colorSombra: const Color(0xFF1971C2),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const HomeButton.iconOnly(),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const AppTexto.titulo(
                  'Practicar',
                  textAlign: TextAlign.center,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Elige un juego rápido para practicar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  children: const [
                    BotonModulo(
                      titulo: 'LETRAS',
                      emoji: '🔤',
                      colorTop: Color(0xFFFF922B),
                      colorSombra: Color(0xFFD9480F),
                      ruta: '/practica_abecedario',
                    ),
                    BotonModulo(
                      titulo: 'NÚMEROS',
                      emoji: '🔢',
                      colorTop: Color(0xFF51CF66),
                      colorSombra: Color(0xFF2F9E44),
                      ruta: '/practica_numeros',
                    ),
                    BotonModulo(
                      titulo: 'COLORES',
                      emoji: '🎨',
                      colorTop: Color(0xFF339AF0),
                      colorSombra: Color(0xFF1971C2),
                      ruta: '/practica_colores',
                    ),
                    BotonModulo(
                      titulo: 'FORMAS',
                      emoji: '🔷',
                      colorTop: Color(0xFFCC5DE8),
                      colorSombra: Color(0xFF9C36B5),
                      ruta: '/practica_formas',
                    ),
                    BotonModulo(
                      titulo: 'ANIMALES',
                      emoji: '🐾',
                      colorTop: Color(0xFF20C997),
                      colorSombra: Color(0xFF0CA678),
                      ruta: '/practica_animales',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
