import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  bool isLoading = true;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> singIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // MODIFICADO: Aceita 'username' para atualizar o Display Name no Firebase
  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String username, // Novo parâmetro
  }) async {
    // 1. Cria a conta no Firebase Auth
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Atualiza o nome de exibição (Display Name) do usuário
    await userCredential.user!.updateDisplayName(username);

    return userCredential;
  }

  Future<void> singOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }
}
