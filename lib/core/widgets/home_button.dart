// lib/core/widgets/home_button.dart

import 'package:flutter/material.dart';

/// Botón reutilizable para volver directamente al menú principal.
///
/// Uso recomendado:
/// HomeButton()
///
/// Este botón limpia la pila de navegación y deja al usuario en /home,
/// así evita tener que presionar varias veces "atrás".
class HomeButton extends StatefulWidget {
  final String texto;
  final IconData icono;
  final Color colorPrincipal;
  final Color colorSombra;
  final bool mostrarTexto;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double fontSize;

  const HomeButton({
    super.key,
    this.texto = 'MENÚ',
    this.icono = Icons.home_rounded,
    this.colorPrincipal = const Color(0xFF339AF0),
    this.colorSombra = const Color(0xFF1971C2),
    this.mostrarTexto = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.iconSize = 20,
    this.fontSize = 14,
  });

  /// Variante pequeña para pantallas con poco espacio.
  const HomeButton.iconOnly({
    super.key,
    this.texto = 'MENÚ',
    this.icono = Icons.home_rounded,
    this.colorPrincipal = const Color(0xFF339AF0),
    this.colorSombra = const Color(0xFF1971C2),
    this.mostrarTexto = false,
    this.padding = const EdgeInsets.all(9),
    this.iconSize = 22,
    this.fontSize = 14,
  });

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  bool _presionado = false;
  static const double _alturaSombra = 4.0;

  void _volverAlMenu() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        _volverAlMenu();
      },
      onTapCancel: () => setState(() => _presionado = false),
      child: Semantics(
        button: true,
        label: 'Volver al menú principal',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          margin: EdgeInsets.only(
            top: _presionado ? _alturaSombra : 0,
            bottom: _presionado ? 0 : _alturaSombra,
          ),
          decoration: BoxDecoration(
            color: widget.colorSombra,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.colorPrincipal,
              borderRadius: BorderRadius.circular(46),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icono,
                  color: Colors.white,
                  size: widget.iconSize,
                ),
                if (widget.mostrarTexto) ...[
                  const SizedBox(width: 6),
                  Text(
                    widget.texto,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: widget.fontSize,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
