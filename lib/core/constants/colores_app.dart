// lib/core/constants/colores_app.dart
// Paleta centralizada de colores y sombras para EduKid
// Todos los fondos son azul claro pastel, así que usamos colores oscuros/vibrantes

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// COLORES DE TEXTO (para usar sobre fondos azul claro pastel)
// ─────────────────────────────────────────────────────────────
class ColoresApp {
  // Para títulos principales (máximo contraste)
  static const Color rojo        = Color(0xFFD90429); // Rojo fuerte ← RECOMENDADO para títulos
  static const Color naranja     = Color(0xFFE85D04); // Naranja oscuro
  static const Color morado      = Color(0xFF6A0572); // Morado oscuro
  static const Color azulMarino  = Color(0xFF023E8A); // Azul marino
  static const Color verdeOscuro = Color(0xFF1B4332); // Verde bosque
  static const Color cafe        = Color(0xFF6B3A2A); // Café oscuro

  // NUEVO: Colores extraídos del logo EduKid (para la pantalla de Bienvenida)
  static const Color azulLogo    = Color(0xFF00B4D8); // El azul de la 'E'
  static const Color amarilloLogo = Color(0xFFFFD60A); // El amarillo de la 'd'
  static const Color magentaLogo  = Color(0xFFF72585); // El rosa/magenta de las flores

  // Para subtítulos (buen contraste, más suave)
  static const Color azulMedio   = Color(0xFF0D3B66); // Azul medio
  static const Color moradoMedio = Color(0xFF3F0A4A); // Morado medio
  static const Color verdeMedio  = Color(0xFF2D6A4F); // Verde medio

  // Para letras grandes en pizarra/práctica (llamativo)
  static const Color naranjaVibrante = Color(0xFFFB8500); // Naranja brillante
  static const Color rojoVibrante    = Color(0xFFEF233C); // Rojo brillante

  // Colores de UI (botones, estrella, estado)
  static const Color estrella    = Color(0xFFFFC300); // Amarillo estrella
  static const Color completado  = Color(0xFF2DC653); // Verde completado
  static const Color enProgreso  = Color(0xFFFFB703); // Amarillo progreso
}

// ─────────────────────────────────────────────────────────────
// SOMBRAS LISTAS PARA USAR
// ─────────────────────────────────────────────────────────────
class SombrasApp {
  // Sombra negra fuerte → para texto de color claro o vibrante sobre fondo pastel
  static const List<Shadow> negra = [
    Shadow(color: Color(0xAA000000), blurRadius: 8, offset: Offset(2, 2)),
    Shadow(color: Color(0x55000000), blurRadius: 16, offset: Offset(0, 0)),
  ];

  // Sombra negra suave → para subtítulos
  static const List<Shadow> negraSubtitulo = [
    Shadow(color: Color(0x88000000), blurRadius: 6, offset: Offset(1, 1)),
  ];

  // Sombra blanca → para texto oscuro sobre fondo claro (da efecto "sticker")
  static const List<Shadow> blanca = [
    Shadow(color: Colors.white, blurRadius: 6, offset: Offset(1, 1)),
    Shadow(color: Colors.white, blurRadius: 2, offset: Offset(-1, -1)),
  ];

  // NUEVO: Sombra "Tipo Sticker" (Borde blanco + Sombra negra)
  // Ideal para fondos con muchos dibujos como el de Bienvenida
  static const List<Shadow> sticker = [
    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(3, 3)),
    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(-3, -3)),
    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(3, -3)),
    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(-3, 3)),
    Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(4, 4)),
  ];

  // Sin sombra → para texto largo/cuerpo
  static const List<Shadow> ninguna = [];
}

// ─────────────────────────────────────────────────────────────
// COMBINACIONES PREDEFINIDAS POR PANTALLA
// ─────────────────────────────────────────────────────────────
class EstilosPantalla {
  // NUEVO: Pantalla de Inicio / Login (fondo.jpg)
  static const Color tituloBienvenida    = ColoresApp.azulLogo;
  static const List<Shadow> sombraBienvenida = SombrasApp.sticker;
  static const Color botonLogin          = ColoresApp.magentaLogo;
  static const Color textoBoton          = Colors.white;

  // Menú principal (fondo_home.png)
  static const Color tituloMenu     = ColoresApp.rojo;
  static const List<Shadow> sombraMenu = SombrasApp.negra;

  // Abecedario (fondo_abecedario.png - letras pastel)
  static const Color tituloAbecedario  = ColoresApp.morado;
  static const List<Shadow> sombraAbecedario = SombrasApp.negra;

  // Números (fondo_numeros.png)
  static const Color tituloNumeros  = ColoresApp.azulMarino;
  static const List<Shadow> sombraNumeros = SombrasApp.negra;

  // Animales (fondo_animales.png)
  static const Color tituloAnimales = ColoresApp.verdeOscuro;
  static const List<Shadow> sombraAnimales = SombrasApp.negra;

  // Colores (fondo_colores.png - nubes y estrellas)
  static const Color tituloColores  = ColoresApp.morado;
  static const List<Shadow> sombraColores = SombrasApp.negra;

  // Formas (fondo_formas.png)
  static const Color tituloFormas   = ColoresApp.cafe;
  static const List<Shadow> sombraFormas = SombrasApp.negra;
}