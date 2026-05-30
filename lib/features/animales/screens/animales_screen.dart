// lib/features/animales/screens/animales_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/home_button.dart';
import '../controllers/animales_controller.dart';

class AnimalesScreen extends StatefulWidget {
  const AnimalesScreen({super.key});

  @override
  State<AnimalesScreen> createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  final AnimalesController _controller = AnimalesController();

  final List<Color> _cardColors = const [
    Color(0xFF8338EC),
    Color(0xFFFFB703),
    Color(0xFFFB5607),
    Color(0xFF06D6A0),
    Color(0xFFFF006E),
    Color(0xFF3A86FF),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.cargarAnimales();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _abrirDetalle(int index) async {
    final animal = _controller.animales[index];

    await Navigator.pushNamed(
      context,
      '/animal_detalle',
      arguments: animal,
    );

    if (mounted) {
      await _controller.cargarAnimales();
    }
  }

  @override
  Widget build(BuildContext context) {
    final animales = _controller.animales;

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
                      _buildTitleChip('Animales'),
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

                _buildProgressChip(
                  '${_controller.animalesCompletados}/10 completados ⭐',
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: _controller.cargando
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD6336C),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.08,
                          ),
                          itemCount: animales.length,
                          itemBuilder: (context, index) {
                            final animal = animales[index];
                            final colorCard =
                                _cardColors[index % _cardColors.length];

                            return GestureDetector(
                              onTap: () => _abrirDetalle(index),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorCard,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 5),
                                          blurRadius: 7,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Image.asset(
                                                animal.imagenSf,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            animal.nombre,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black45,
                                                  blurRadius: 3,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (animal.completado)
                                    Positioned(
                                      top: -6,
                                      left: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 24,
                                        ),
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

  Widget _buildTitleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
          fontSize: 26,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildProgressChip(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1B3B6F),
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
}
