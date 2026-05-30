// lib/core/service/google_sign_in_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<({UserCredential credential, bool isNewUser})?>
      signInWithGoogle() async {
    await _googleSignIn.signOut();

    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final oauthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    final user = userCredential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'google-user-null',
        message: 'No se pudo obtener el usuario de Google.',
      );
    }

    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

    await _safeEnsureGoogleUserDocument(user);

    return (credential: userCredential, isNewUser: isNewUser);
  }

  Future<void> _safeEnsureGoogleUserDocument(User user) async {
    try {
      final docRef = _db.collection('users').doc(user.uid);
      final snapshot = await docRef.get();

      final data = <String, dynamic>{
        'uid': user.uid,
        'email': user.email ?? '',
        'nombre': user.displayName ?? '',
        'fotoUrl': user.photoURL ?? '',
        'metodo': 'google',
        'actualizadoEn': FieldValue.serverTimestamp(),
      };

      if (!snapshot.exists) {
        data['creadoEn'] = FieldValue.serverTimestamp();
      }

      await docRef.set(data, SetOptions(merge: true));
    } catch (_) {
      // No bloquear el acceso si Firestore falla.
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
