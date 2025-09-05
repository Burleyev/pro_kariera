import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro_kariera/admin/app/widgets_admin/about_me_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/avgs_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/contact_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/faq_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/header_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/hero_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/how_i_work_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/price_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/service_admin.dart';
import 'package:pro_kariera/admin/app/widgets_admin/testimonials_admin.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Админка",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text("Сообщения"),
              onTap: () {
                Navigator.pushNamed(context, '/admin/messages');
              },
            ),
            ListTile(
              title: const Text("Выйти"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          HeaderAdmin(),
          HeroAdmin(),
          AboutMeAdmin(),
          ServiceAdmin(),
          PriceAdmin(),
          AvgsAdmin(),
          HowIWorkAdmin(),
          TestimonialsAdmin(),
          FaqAdmin(),
          ContactAdmin(),
        ],
      ),
    );
  }
}
