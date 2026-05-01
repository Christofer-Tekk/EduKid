// lib/core/widgets/app_texto.dart
// Widget de texto reutilizable para EduKid
// Diseñado para contrastar sobre fondos azul claro pastel

import 'package:flutter/material.dart';
import '../constants/colores_app.dart';

class AppTexto extends StatelessWidget {
  final String texto;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final List<Shadow>? shadows;

  // ── TÍTULO ──────────────────────────────────────────────────
  // Uso: AppTexto.titulo('Abecedario')
  // Uso con color personalizado: AppTexto.titulo('Abecedario', color: ColoresApp.morado)
  const AppTexto.titulo(
    this.texto, {
    Key? key,
    this.fontSize = 28,
    this.fontWeight = FontWeight.w900,
    this.color = ColoresApp.rojo,           // rojo fuerte por defecto
    this.textAlign = TextAlign.start,
    this.shadows = SombrasApp.negra,
  }) : super(key: key);

  // ── SUBTÍTULO ────────────────────────────────────────────────
  // Uso: AppTexto.subtitulo('3/27 completadas')
  const AppTexto.subtitulo(
    this.texto, {
    Key? key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w800,
    this.color = ColoresApp.azulMedio,       // azul marino por defecto
    this.textAlign = TextAlign.start,
    this.shadows = SombrasApp.negraSubtitulo,
  }) : super(key: key);

  // ── CUERPO ───────────────────────────────────────────────────
  // Uso: AppTexto.cuerpo('Traza la letra sobre la guía')
  const AppTexto.cuerpo(
    this.texto, {
    Key? key,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
    this.color = ColoresApp.moradoMedio,
    this.textAlign = TextAlign.start,
    this.shadows,                            // sin sombra por defecto para texto largo
  }) : super(key: key);

  // ── LETRA GRANDE ─────────────────────────────────────────────
  // Uso en pizarra y detalle: AppTexto.letraGrande('A')
  const AppTexto.letraGrande(
    this.texto, {
    Key? key,
    this.fontSize = 80,
    this.fontWeight = FontWeight.w900,
    this.color = ColoresApp.naranjaVibrante,
    this.textAlign = TextAlign.center,
    this.shadows = SombrasApp.negra,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        shadows: shadows,
      ),
    );
  }
}