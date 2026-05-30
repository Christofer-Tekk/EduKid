// lib/features/animales/screens/animal_detalle_screen.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/home_button.dart';
import '../../../data/models/animal_model.dart';

class AnimalDetalleScreen extends StatelessWidget {
  const AnimalDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animal = ModalRoute.of(context)!.settings.arguments as AnimalModel;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_animales.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(
                    children: [
                      Expanded(child: _buildTitleCard(animal.nombre)),
                      const SizedBox(width: 8),
                      const HomeButton.iconOnly(),
                      const SizedBox(width: 8),
                      _buildBackButton(context),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _buildAnimalCard(animal),
                        const SizedBox(height: 24),
                        _buildListenButton(animal),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _buildPracticeButton(context, animal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleCard(String nombre) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          nombre.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFD6336C),
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'VOLVER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF339AF0),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        elevation: 5,
        side: const BorderSide(color: Colors.white, width: 3),
      ),
    );
  }

  Widget _buildAnimalCard(AnimalModel animal) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              animal.imagen,
              height: 245,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3F8),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFD6336C).withOpacity(0.25),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  animal.imagenSf,
                  height: 42,
                  width: 42,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Animal: ${animal.nombre}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF1B3B6F),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
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

  Widget _buildListenButton(AnimalModel animal) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            final player = AudioPlayer();
            final ruta = animal.audioNombre.replaceFirst('assets/', '');
            await player.play(AssetSource(ruta));
          } catch (e) {
            debugPrint('Error al reproducir audio: $e');
          }
        },
        icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
        label: const Text(
          'ESCUCHAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF51CF66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildPracticeButton(BuildContext context, AnimalModel animal) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/animal_practica',
            arguments: animal,
          );
        },
        icon: const Icon(Icons.videogame_asset, color: Colors.white),
        label: const Text(
          'PRACTICAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF339AF0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
