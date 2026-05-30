// lib/features/pizarra/screens/pizarra_colorear_lista_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';

class ColorearItem {
  final String nombre;
  final String rutaImagen;
  final String emoji;

  const ColorearItem({
    required this.nombre,
    required this.rutaImagen,
    required this.emoji,
  });
}

const List<ColorearItem> dibujosParaColorear = [
  ColorearItem(nombre: 'Auto', rutaImagen: 'assets/images/colorear/auto.png', emoji: '🚗'),
  ColorearItem(nombre: 'Camisa', rutaImagen: 'assets/images/colorear/camisa.png', emoji: '👕'),
  ColorearItem(nombre: 'Casa', rutaImagen: 'assets/images/colorear/casa.png', emoji: '🏠'),
  ColorearItem(nombre: 'Flor', rutaImagen: 'assets/images/colorear/flor.png', emoji: '🌸'),
  ColorearItem(nombre: 'Lápiz', rutaImagen: 'assets/images/colorear/lapiz.png', emoji: '✏️'),
  ColorearItem(nombre: 'Manzana', rutaImagen: 'assets/images/colorear/manzana.png', emoji: '🍎'),
  ColorearItem(nombre: 'Mochila', rutaImagen: 'assets/images/colorear/mochila.png', emoji: '🎒'),
  ColorearItem(nombre: 'Pato', rutaImagen: 'assets/images/colorear/pato.png', emoji: '🦆'),
  ColorearItem(nombre: 'Pez', rutaImagen: 'assets/images/colorear/pez.png', emoji: '🐟'),
  ColorearItem(nombre: 'Sol', rutaImagen: 'assets/images/colorear/sol.png', emoji: '☀️'),
];

class PizarraColorearListaScreen extends StatelessWidget {
  const PizarraColorearListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.pizarra,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(26),
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
                  'Colorear',
                  textAlign: TextAlign.center,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Elige un dibujo para pintar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: dibujosParaColorear.length,
                  itemBuilder: (context, index) {
                    final item = dibujosParaColorear[index];
                    return _DibujoCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DibujoCard extends StatelessWidget {
  final ColorearItem item;

  const _DibujoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/pizarra_colorear',
        arguments: item,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                child: Image.asset(
                  item.rutaImagen,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 54),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B9D),
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: Text(
                item.nombre.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
