import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projects/admin/views/auth/admin_login.dart';
import 'package:projects/admin/views/home_screen/admin_homescreen.dart';
import 'package:projects/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AntiqueCrafts',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      

      // INITIAL ROUTE
      home: const AdminLoginScreen(),

    );
  }
}