// lib/features/abecedario/screens/abecedario_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colores_app.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/estado_item.dart';
import '../controllers/abecedario_controller.dart';

class AbecedarioScreen extends StatelessWidget {
  const AbecedarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AbecedarioController(),
      child: BackgroundWrapper(
        assetPath: AppFondos.abecedario,
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
                        child: _TituloAbecedarioCard(texto: 'Abecedario'),
                      ),
                    ),
                    const SizedBox(width: 12),
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

              Consumer<AbecedarioController>(
                builder: (context, controller, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _ProgresoCard(
                    texto: '${controller.letrasCompletadas}/27 completadas ⭐',
                  ),
                ),
              ),

              Expanded(
                child: Consumer<AbecedarioController>(
                  builder: (context, controller, _) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(14),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller.letras.length,
                      itemBuilder: (context, index) {
                        final letra = controller.letras[index];
                        return EstadoItem(
                          texto: letra.letraMayuscula,
                          color: _obtenerColor(index),
                          estado: letra.estado,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/letra_detalle',
                              arguments: letra,
                            );
                            controller.cargarLetras();
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

class _TituloAbecedarioCard extends StatelessWidget {
  final String texto;

  const _TituloAbecedarioCard({required this.texto});

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
            color: ColoresApp.morado,
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
