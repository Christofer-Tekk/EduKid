import '../models/numero_model.dart';

// Lista de nombres para mapear del 1 al 20
const List<String> _nombresNumeros = [
  "Cero", "Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis", "Siete", "Ocho", "Nueve", "Diez",
  "Once", "Doce", "Trece", "Catorce", "Quince", "Dieciséis", "Diecisiete", "Dieciocho", "Diecinueve", "Veinte"
];

// Generamos automáticamente los 20 números
final List<NumeroModel> listaNumeros = List.generate(20, (index) {
  int numero = index + 1; // Para que empiece en 1 y termine en 20
  return NumeroModel(
    valor: numero,
    nombre: _nombresNumeros[numero],
    imagen: "assets/images/numeros/$numero.png", // Ej: assets/images/numeros/1.png
    audio: "assets/audio/numeros/$numero.mp3",   // Ej: assets/audio/numeros/1.mp3
    videoUrl: "ID_YOUTUBE_AQUI", // Déjalo así por ahora, luego pondrás el ID del video
  );
});