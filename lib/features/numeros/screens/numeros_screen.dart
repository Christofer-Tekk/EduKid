// lib/features/numeros/screens/numeros_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/home_button.dart';
import '../controllers/numeros_controller.dart';

class NumerosScreen extends StatelessWidget {
  const NumerosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NumerosController(),
      child: BackgroundWrapper(
        assetPath: AppFondos.numeros,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _TituloNumerosCard(texto: 'Números'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const HomeButton.iconOnly(),
                    const SizedBox(width: 10),
                    BotonAccion(
                      texto: 'VOLVER',
                      icono: Icons.arrow_back,
                      colorPrincipal: Colors.blue,
                      colorSombra: const Color(0xFF1971C2),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Consumer<NumerosController>(
                builder: (context, controller, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _ProgresoCard(
                    texto: '${controller.numerosCompletados}/20 completados ⭐',
                  ),
                ),
              ),
              Expanded(
                child: Consumer<NumerosController>(
                  builder: (context, controller, _) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(14),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller.numeros.length,
                      itemBuilder: (context, index) {
                        final numero = controller.numeros[index];

                        return _NumeroItem(
                          texto: numero.valor.toString(),
                          color: _obtenerColor(index),
                          completado: numero.completado,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/numero_detalle',
                              arguments: numero,
                            );
                            controller.cargarNumeros();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _obtenerColor(int index) {
    final colores = [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF922B),
      const Color(0xFFFFD166),
      const Color(0xFF51CF66),
      const Color(0xFF339AF0),
      const Color(0xFFCC5DE8),
      const Color(0xFF20C997),
      const Color(0xFFFF6B9D),
    ];

    return colores[index % colores.length];
  }
}

class _NumeroItem extends StatelessWidget {
  final String texto;
  final Color color;
  final bool completado;
  final VoidCallback onTap;

  const _NumeroItem({
    required this.texto,
    required this.color,
    required this.completado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 3,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (completado)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: const Icon(
                  Icons.star,
                  color: ColoresApp.estrella,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TituloNumerosCard extends StatelessWidget {
  final String texto;

  const _TituloNumerosCard({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          texto,
          style: const TextStyle(
            color: ColoresApp.rojo,
            fontSize: 27,
            fontWeight: FontWeight.w900,
            shadows: SombrasApp.blanca,
          ),
        ),
      ),
    );
  }
}

class _ProgresoCard extends StatelessWidget {
  final String texto;

  const _ProgresoCard({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.86),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ColoresApp.azulMedio,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            shadows: SombrasApp.blanca,
          ),
        ),
      ),
    );
  }
}
