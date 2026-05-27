import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../data/models/animal_model.dart';

class AnimalDetalleScreen extends StatelessWidget {
  const AnimalDetalleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recibe la información del animal
    final animal = ModalRoute.of(context)!.settings.arguments as AnimalModel;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo consistente
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_animales.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // BARRA SUPERIOR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                        ),
                        child: Text(
                          animal.nombre.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFD6336C),
                            fontSize: 24, 
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        label: const Text('VOLVER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF339AF0),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // CONTENIDO CENTRAL
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        // Imagen Principal del Animal
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(animal.imagen, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // BOTÓN ÚNICO: ESCUCHAR
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final player = AudioPlayer();
                                // Flutter requiere que la ruta de audioplayers no tenga la palabra "assets/"
                                String ruta = animal.audioNombre.replaceFirst('assets/', '');
                                await player.play(AssetSource(ruta));
                              } catch (e) {
                                print("Error al reproducir audio: $e");
                              }
                            },
                            icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
                            label: const Text('ESCUCHAR', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF51CF66), // Verde
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botón PRACTICAR (Para el minijuego)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navegación pendiente hacia el minijuego
                        Navigator.pushNamed(context, '/animal_practica', arguments: animal);
                      },
                      icon: const Icon(Icons.videogame_asset, color: Colors.white),
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
        ],
      ),
    );
  }
}