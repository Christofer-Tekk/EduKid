// lib/features/abecedario/screens/abecedario_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/estado_item.dart';
import '../../../core/widgets/app_texto.dart';
import '../controllers/abecedario_controller.dart';

class AbecedarioScreen extends StatelessWidget {
  const AbecedarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AbecedarioController(),
      child: BackgroundWrapper(
        assetPath: 'assets/images/fondo/fondo_abecedario.png',
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppTexto.titulo('Abecedario'),
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

              // Progreso
              Consumer<AbecedarioController>(
                builder: (context, controller, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: AppTexto.subtitulo(
                    '${controller.letrasCompletadas}/27 completadas ⭐',
                  ),
                ),
              ),

              // GRID de letras
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
                            // Al volver recarga el progreso
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