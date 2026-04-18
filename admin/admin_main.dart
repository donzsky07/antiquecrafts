import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projects/admin/views/home_screen/admin_homescreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      appId: "YOUR_APP_ID",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "YOUR_PROJECT_ID",
      storageBucket: "YOUR_BUCKET",
    ),
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
      home: const AdminHomeScreen(),

    );
  }
}