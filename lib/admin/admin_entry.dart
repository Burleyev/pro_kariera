import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro_kariera/admin/app/admin_app.dart';
import 'package:pro_kariera/admin/auth/ui/login_screen.dart';

class AdminEntry extends StatelessWidget {
  const AdminEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        // Не залогинен → экран логина
        if (!authSnap.hasData) {
          return const LoginScreen();
        }
        final user = authSnap.data!;

        // Проверяем custom claims (admin)
        return FutureBuilder(
          future: user.getIdTokenResult(true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Ошибка проверки прав: ${snapshot.error}'),
                ),
              );
            }
            final claims = snapshot.data?.claims;
            final isAdmin = claims != null && claims['admin'] == true;
            if (isAdmin) {
              return const AdminApp();
            }
            return const Scaffold(
              body: Center(child: Text('Нет прав администратора')),
            );
          },
        );
      },
    );
  }
}
