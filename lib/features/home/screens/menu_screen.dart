// lib/features/home/screens/menu_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_modulo.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/app_texto.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BackgroundWrapper(
      assetPath: 'assets/images/fondo/fondo_home.png',
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, user),
            const SizedBox(height: 4),

            // Solo se mejoró la legibilidad del título.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const AppTexto.titulo(
                  '¿Qué quieres aprender?',
                  textAlign: TextAlign.center,
                  fontSize: 27,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  BotonModulo(
                    titulo: 'ABECEDARIO',
                    emoji: '🔤',
                    colorTop: const Color(0xFFFF922B),
                    colorSombra: const Color(0xFFD9480F),
                    ruta: '/letras',
                  ),
                  BotonModulo(
                    titulo: 'NÚMEROS',
                    emoji: '🔢',
                    colorTop: const Color(0xFF51CF66),
                    colorSombra: const Color(0xFF2F9E44),
                    ruta: '/numeros',
                  ),
                  BotonModulo(
                    titulo: 'COLORES',
                    emoji: '🎨',
                    colorTop: const Color(0xFF339AF0),
                    colorSombra: const Color(0xFF1971C2),
                    ruta: '/colores',
                  ),
                  BotonModulo(
                    titulo: 'FORMAS',
                    emoji: '🔷',
                    colorTop: const Color(0xFFCC5DE8),
                    colorSombra: const Color(0xFF9C36B5),
                    ruta: '/formas',
                  ),
                  BotonModulo(
                    titulo: 'ANIMALES',
                    emoji: '🐾',
                    colorTop: const Color(0xFF20C997),
                    colorSombra: const Color(0xFF0CA678),
                    ruta: '/animales',
                  ),
                  BotonModulo(
                    titulo: 'PIZARRA',
                    emoji: '✏️',
                    colorTop: const Color(0xFFFF6B9D),
                    colorSombra: const Color(0xFFD6336C),
                    ruta: '/pizarra_libre',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFFFD166),
              backgroundImage: (user?.photoURL != null)
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: (user?.photoURL == null)
                  ? const Text('😊', style: TextStyle(fontSize: 28))
                  : null,
            ),
          ),
          BotonAccion(
            texto: 'SALIR',
            icono: Icons.logout_rounded,
            colorPrincipal: Colors.redAccent,
            colorSombra: const Color(0xFFC0392B),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
