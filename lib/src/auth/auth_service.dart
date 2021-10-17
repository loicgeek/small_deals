import 'package:firebase_auth/firebase_auth.dart';
import 'package:small_deals/src/user/user_service.dart';

class AuthService {
  late UserService _userService;

  AuthService() {
    _userService = UserService();
  }

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
    required String username,
  }) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    _userService.updateAccount(userCredential.user!.uid, {
      "email": email.trim(),
      "username": username,
    });

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
