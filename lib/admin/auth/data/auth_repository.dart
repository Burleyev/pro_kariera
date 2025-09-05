import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  // Возвращаем UserCredential и форсим обновление токена (чтобы подтянулись claims)
  Future<UserCredential> signInEmail(String email, String pass) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
    await cred.user?.getIdTokenResult(true); // force refresh claims
    return cred;
  }

  Future<void> signOut() => _auth.signOut();

  // Удобный хелпер: перечитать клеймы
  Future<Map<String, dynamic>?> refreshClaims() async {
    final res = await _auth.currentUser?.getIdTokenResult(true);
    return res?.claims;
  }

  // Проверка: админ ли текущий пользователь
  Future<bool> isCurrentUserAdmin() async {
    final claims = await refreshClaims();
    return claims?['admin'] == true;
  }
}
