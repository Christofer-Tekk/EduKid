import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../data/models/numero_model.dart';

class NumeroDetalleScreen extends StatefulWidget {
  const NumeroDetalleScreen({Key? key}) : super(key: key);

  @override
  State<NumeroDetalleScreen> createState() => _NumeroDetalleScreenState();
}

class _NumeroDetalleScreenState extends State<NumeroDetalleScreen> {
  late YoutubePlayerController _youtubeController;
  late NumeroModel numero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibimos el número
    numero = ModalRoute.of(context)!.settings.arguments as NumeroModel;
    
    // Configuramos el reproductor de YouTube con el ID del video
    _youtubeController = YoutubePlayerController(
      initialVideoId: numero.videoUrl,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // Para que no suene de golpe al entrar
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    // Es muy importante apagar el video al salir de la pantalla
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de números
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo/fondo_numeros.png',
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
                          '${numero.valor} ${numero.nombre.toUpperCase()}',
                          style: const TextStyle(color: Color(0xFFD6336C), fontSize: 24, fontWeight: FontWeight.w900),
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
                
                // CONTENIDO SCROLL
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        // Imagen Principal
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
                            child: Image.asset(numero.imagen, fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botón ESCUCHAR
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final player = AudioPlayer();
                              String ruta = numero.audio.replaceAll('assets/', '');
                              await player.play(AssetSource(ruta));
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

                        // Título del Video
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('Video Educativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // REPRODUCTOR DE YOUTUBE REAL
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: YoutubePlayer(
                              controller: _youtubeController,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: const Color(0xFFD6336C),
                              progressColors: const ProgressBarColors(
                                playedColor: Color(0xFFD6336C),
                                handleColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botón PRACTICAR
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Pausamos el video si entra a practicar
                        _youtubeController.pause();
                        Navigator.pushNamed(context, '/numero_practica', arguments: numero);
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
        ],
      ),
    );
  }
}