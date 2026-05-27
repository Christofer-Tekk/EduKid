// lib/core/service/google_sign_in_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retorna el UserCredential si el login fue exitoso.
  /// Lanza [GoogleSignInCancelled] si el usuario canceló.
  /// [isNewUser] indica si es la primera vez que se registra.
  Future<({UserCredential credential, bool isNewUser})?>
      signInWithGoogle() async {
    // Cerrar sesión previa de Google para forzar selector de cuenta
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Usuario canceló
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final oauthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(oauthCredential);

    final isNewUser =
        userCredential.additionalUserInfo?.isNewUser ?? false;

    // Si es usuario nuevo, guardar en Firestore
    if (isNewUser) {
      try {
        await _db
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email ?? '',
          'nombre': userCredential.user!.displayName ?? '',
          'creadoEn': FieldValue.serverTimestamp(),
          'metodo': 'google',
        });
      } catch (_) {
        // No bloquear si Firestore falla
      }
    }

    return (credential: userCredential, isNewUser: isNewUser);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
