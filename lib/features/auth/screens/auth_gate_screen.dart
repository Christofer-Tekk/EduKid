// lib/features/auth/screens/auth_gate_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/screens/menu_screen.dart';
import 'login_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFFF8E1),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF8C00),
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MenuScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
