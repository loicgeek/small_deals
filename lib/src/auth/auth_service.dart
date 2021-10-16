import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get userStream {
    return FirebaseAuth.instance.authStateChanges();
  }

  User? get user {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    return userCredential;
  }

  loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    return userCredential;
  }

  loginWithGoogle() {}

  logout() async {
    await auth.signOut();
  }
}
