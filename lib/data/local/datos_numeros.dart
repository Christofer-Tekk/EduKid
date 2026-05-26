// lib/data/local/datos_numeros.dart

import '../models/numero_model.dart';

const List<String> _nombresNumeros = [
  'Cero',
  'Uno',
  'Dos',
  'Tres',
  'Cuatro',
  'Cinco',
  'Seis',
  'Siete',
  'Ocho',
  'Nueve',
  'Diez',
  'Once',
  'Doce',
  'Trece',
  'Catorce',
  'Quince',
  'Dieciséis',
  'Diecisiete',
  'Dieciocho',
  'Diecinueve',
  'Veinte',
];

const List<String> _videoIds = [
  'd4JepcNsFXI',
  'VEVCvcgH0dA',
  'xaUBbc7kyCo',
  'Du7S2jXAhhU',
  'xvuylOwP2n4',
  'gxCCE_o1wq0',
  '-WTBhhbUn1Y',
  'Q2PharRk1Sc',
  '6OVkCV9QK78',
  'njMvN0ozcK8',
  'AcnDpsOoACE',
  'R4vYXbiD58Y',
  'SYofRhvtGDM',
  'iRh__8TMZW0',
  'XrqqykDxTxc',
  'KHunhY_2Ri4',
  'k4aueK0oWNA',
  'hOrEgaTZZ7k',
  'WkTmyjX3Zo4',
  'GhzEclnqtU8',
];

class DatosNumeros {
  static List<NumeroModel> obtenerNumeros() {
    return List.generate(20, (index) {
      final numero = index + 1;

      return NumeroModel(
        valor: numero,
        nombre: _nombresNumeros[numero],
        imagen: 'assets/images/numeros/$numero.png',
        audio: 'assets/audio/numeros/$numero.mp3',
        videoUrl: _videoIds[index],
      );
    });
  }
}

// Se mantiene para compatibilidad con pantallas antiguas.
final List<NumeroModel> listaNumeros = DatosNumeros.obtenerNumeros();
