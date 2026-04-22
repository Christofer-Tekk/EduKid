import 'package:flutter/material.dart';

class EstadoItem extends StatelessWidget {
  final String texto;
  final Color color;
  final bool completado;
  final VoidCallback onTap;

  const EstadoItem({
    super.key,
    required this.texto,
    required this.color,
    required this.completado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                texto,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          if (completado)
            const Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
