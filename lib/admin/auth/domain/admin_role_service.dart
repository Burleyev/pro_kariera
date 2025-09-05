import 'package:firebase_auth/firebase_auth.dart';

class AdminRoleService {
  Future<bool> isAdmin() async {
    final res = await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
    return res?.claims?['admin'] == true;
  }
}
