import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Stream del usuario actual ─────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ── Iniciar sesión ────────────────────────────────────────────
  /// Inicia sesión y verifica que el rol almacenado en Firestore coincida.
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

  // ── Registrar usuario ─────────────────────────────────────────
  Future<UserCredential> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Actualizar displayName
    await credential.user!.updateDisplayName(displayName);

    // Guardar rol en Firestore
    await _db.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // ── Cerrar sesión ─────────────────────────────────────────────
  Future<void> signOut() => _auth.signOut();

  // ── Restablecer contraseña ────────────────────────────────────
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);
}

