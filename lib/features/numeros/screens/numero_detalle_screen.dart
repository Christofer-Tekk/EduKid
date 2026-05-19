import 'package:flutter/material.dart';
import '../../../data/models/numero_model.dart';

class NumeroDetalleScreen extends StatelessWidget {
  const NumeroDetalleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Esto "atrapa" la información del número que el niño tocó en la cuadrícula
    final numero = ModalRoute.of(context)!.settings.arguments as NumeroModel;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Mismo fondo celeste
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. BARRA SUPERIOR ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${numero.valor} ${numero.nombre}', // Ej: "1 Uno"
                    style: const TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.redAccent,
                      shadows: [Shadow(color: Colors.white, blurRadius: 3)]
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF339AF0),
                      shape: const StadiumBorder(),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. CONTENIDO DESPLAZABLE ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Imagen Principal del Número (El perrito)
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(numero.imagen, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botón ESCUCHAR (Verde)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Cuando tengan el AudioService, aquí se pone: AudioService.reproducir(numero.audio);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('🎵 Reproduciendo audio: ${numero.nombre}')),
                          );
                        },
                        icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
                        label: const Text('ESCUCHAR', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF51CF66),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Título de la sección de Video
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Video Educativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Botón GIGANTE DE VIDEO (Morado)
                    GestureDetector(
                      onTap: () {
                        // Aquí conectarán con YouTube más adelante
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📺 Abriendo video en YouTube...')),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE599F7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))],
                        ),
                        child: const Center(
                          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 3. BOTÓN PRACTICAR (Fijo en la parte inferior) ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                 onPressed: () {
                   Navigator.pushNamed(
                     context, 
                     '/numero_practica', 
                     arguments: numero,
                   );
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('PRACTICAR', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339AF0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}