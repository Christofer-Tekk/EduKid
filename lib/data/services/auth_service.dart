// lib/data/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    final credential = await _auth.signInWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    await _safeEnsureEmailUserDocument(credential.user, normalizedEmail);

    return credential;
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    await _validateEmailProviders(normalizedEmail);

    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    await _safeEnsureEmailUserDocument(credential.user, normalizedEmail);

    return credential;
  }

  Future<void> _validateEmailProviders(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);

      if (methods.contains('google.com') && !methods.contains('password')) {
        throw FirebaseAuthException(
          code: 'email-already-google',
          message: 'Este correo ya está registrado con Google.',
        );
      }

      if (methods.contains('password')) {
        throw FirebaseAuthException(
          code: 'email-already-password',
          message: 'Este correo ya está registrado con correo y contraseña.',
        );
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      // Si no se puede consultar proveedores, dejamos que Firebase valide al crear.
    }
  }

  Future<void> _safeEnsureEmailUserDocument(
    User? user,
    String email,
  ) async {
    if (user == null) return;

    try {
      final docRef = _db.collection('users').doc(user.uid);
      final snapshot = await docRef.get();

      final data = <String, dynamic>{
        'uid': user.uid,
        'email': email,
        'metodo': 'correo',
        'actualizadoEn': FieldValue.serverTimestamp(),
      };

      if (!snapshot.exists) {
        data['creadoEn'] = FieldValue.serverTimestamp();
      }

      await docRef.set(data, SetOptions(merge: true));
    } catch (_) {
      // No bloquear login/registro si Firestore falla.
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
