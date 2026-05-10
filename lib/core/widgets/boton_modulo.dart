import 'package:flutter/material.dart';

class BotonModulo extends StatefulWidget {
  final String titulo;
  final String emoji;
  final Color colorTop;
  final Color colorSombra;
  final String ruta;
  final VoidCallback? onTap;

  const BotonModulo({
    Key? key,
    required this.titulo,
    required this.emoji,
    required this.colorTop,
    required this.colorSombra,
    required this.ruta,
    this.onTap,
  }) : super(key: key);

  @override
  State<BotonModulo> createState() => _BotonModuloState();
}

class _BotonModuloState extends State<BotonModulo> {
  bool _presionado = false;
  static const double _alturaSombra = 6.0;

  void _navegar(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.pushNamed(context, widget.ruta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        _navegar(context);
      },
      onTapCancel: () => setState(() => _presionado = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(
          top: _presionado ? _alturaSombra : 0,
          bottom: _presionado ? 0 : _alturaSombra,
        ),
        decoration: BoxDecoration(
          color: widget.colorSombra,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.colorTop,
                widget.colorTop.withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 52),
              ),
              const SizedBox(height: 8),
              Text(
                widget.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(color: Colors.black38, blurRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}