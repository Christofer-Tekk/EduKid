// lib/features/colores/screens/colores_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';
import '../../../data/models/color_model.dart';
import '../controllers/colores_controller.dart';

class ColoresScreen extends StatefulWidget {
  const ColoresScreen({super.key});

  @override
  State<ColoresScreen> createState() => _ColoresScreenState();
}

class _ColoresScreenState extends State<ColoresScreen> {
  late final ColoresController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ColoresController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: AppFondos.colores,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Row(
                    children: [
                      Expanded(child: _buildTitleCard()),
                      const SizedBox(width: 8),
                      const HomeButton.iconOnly(),
                      const SizedBox(width: 8),
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

                _buildProgressCard(),

                const SizedBox(height: 8),

                Expanded(
                  child: _controller.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
                          itemCount: _controller.colores.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 18,
                            childAspectRatio: 0.92,
                          ),
                          itemBuilder: (context, index) {
                            final color = _controller.colores[index];
                            return _ColorButton(
                              colorItem: color,
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/color_detalle',
                                  arguments: color,
                                );
                                await _controller.cargarColores();
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AppTexto.titulo(
          'Colores',
          color: EstilosPantalla.tituloColores,
          shadows: SombrasApp.blanca,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppTexto.subtitulo(
        '${_controller.completados}/${_controller.colores.length} completados ⭐',
        textAlign: TextAlign.center,
        color: ColoresApp.azulMedio,
        shadows: SombrasApp.blanca,
        fontSize: 18,
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final ColorModel colorItem;
  final VoidCallback onTap;

  const _ColorButton({
    required this.colorItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(colorItem.colorHex);
    final isWhite = colorItem.clave == 'blanco';
    final completed = colorItem.estado == 'completado';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(80),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(
                      color: isWhite ? Colors.black38 : Colors.white,
                      width: isWhite ? 3 : 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(isWhite ? 0.22 : 0.40),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 9,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                if (completed)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: ColoresApp.estrella,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.24),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                colorItem.nombreMayuscula,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isWhite ? Colors.black87 : color,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  shadows: const [
                    Shadow(color: Colors.white, blurRadius: 5),
                    Shadow(color: Colors.white, blurRadius: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
