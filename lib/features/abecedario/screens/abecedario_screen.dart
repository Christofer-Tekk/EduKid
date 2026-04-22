import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/estado_item.dart';
import '../../../data/services/progreso_service.dart';

class AbecedarioScreen extends StatelessWidget {
  const AbecedarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abecedario"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: AppConstants.letras.length,
        itemBuilder: (context, index) {
          final letra = AppConstants.letras[index];
          final color = AppConstants.colores[index % AppConstants.colores.length];

          return EstadoItem(
            texto: letra,
            color: color,
            completado: ProgresoService.estaCompleto(letra),
            onTap: () {
              // Simulación: marcar como completado
              ProgresoService.completar(letra);

              // Refrescar pantalla
              (context as Element).markNeedsBuild();
            },
          );
        },
      ),
    );
  }
}
