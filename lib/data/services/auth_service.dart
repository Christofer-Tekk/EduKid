import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final cleanName = displayName?.trim();

    if (cleanName != null && cleanName.isNotEmpty) {
      await credential.user?.updateDisplayName(cleanName);
    }

    final userData = <String, dynamic>{
      'uid': credential.user!.uid,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (cleanName != null && cleanName.isNotEmpty) {
      userData['displayName'] = cleanName;
    }

    await _db.collection('users').doc(credential.user!.uid).set(
          userData,
          SetOptions(merge: true),
        );

    return credential;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
