// lib/data/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Iniciar sesión con correo ─────────────────────────────────
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  // ── Registrar con correo ──────────────────────────────────────
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Guardar en Firestore (sin bloquear el login si falla)
    try {
      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'creadoEn': FieldValue.serverTimestamp(),
        'metodo': 'correo',
      });
    } catch (_) {
      // No bloquear el registro si Firestore falla
    }

    return credential;
  }

  // ── Restablecer contraseña ────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Cerrar sesión ─────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Usuario actual ────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
