import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:projects/admin/views/auth/admin_login.dart';
import 'package:projects/admin/views/home_screen/admin_homescreen.dart';

class AdminAuthController extends GetxController {
  static AdminAuthController instance = Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;

  /// TEXT CONTROLLERS
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  /// LOADING STATE
  var isLoading = false.obs;

  /// -------------------------
  /// ADMIN LOGIN
  /// -------------------------
  Future<void> loginAdmin() async {
  try {
    isLoading(true);

    await auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    Get.snackbar(
      "Success",
      "Welcome Admin",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    /// ✅ REDIRECT TO ADMIN HOME
    Get.offAll(() => const AdminHomeScreen());

  } catch (e) {
    Get.snackbar(
      "Login Failed",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading(false);
  }
}

  /// -------------------------
  /// ADMIN SIGNUP
  /// -------------------------
 Future<void> signupAdmin() async {
  try {
    isLoading(true);

    await auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    Get.snackbar(
      "Success",
      "Admin account created",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    /// ✅ AFTER SIGNUP → GO BACK TO LOGIN PAGE
 Get.offAll(() =>  AdminLoginScreen());

  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading(false);
  }
}
  /// -------------------------
  /// LOGOUT
  /// -------------------------
 Future<void> logoutAdmin() async {
  try {
    await auth.signOut();

    Get.snackbar(
      "Logged out",
      "Admin session ended",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );

    /// ✅ BACK TO LOGIN
    Get.offAll(() =>  AdminLoginScreen());

  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  /// CLEAR FIELDS
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
