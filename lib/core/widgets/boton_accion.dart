import 'package:flutter/material.dart';

class BotonAccion extends StatefulWidget {
  final String texto;
  final IconData icono;
  final Color colorPrincipal;
  final Color colorSombra;
  final VoidCallback onPressed;

  const BotonAccion({
    Key? key,
    required this.texto,
    required this.icono,
    required this.colorPrincipal,
    required this.colorSombra,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<BotonAccion> createState() => _BotonAccionState();
}

class _BotonAccionState extends State<BotonAccion> {
  bool _presionado = false;
  static const double _alturaSombra = 4.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        widget.onPressed();
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
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.colorPrincipal,
            borderRadius: BorderRadius.circular(46),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icono, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                widget.texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}