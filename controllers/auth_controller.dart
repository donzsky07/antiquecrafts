
/*import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/auth_screen/login_screen.dart';
import 'package:projects/views/home_screen/home.dart';


class AuthController extends GetxController {
  // Reactive loading variable
  var isLoading = false.obs;

  // Text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // LOGIN
  Future<void> login() async {
    isLoading.value = true;

    try {
      // Firebase authentication
      final userCred = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCred.user!.uid;

      // Fetch user data from Firestore
      final userDoc = await _firestore.collection(usersCollection).doc(uid).get();

      if (!userDoc.exists) {
        await _auth.signOut();
        Get.snackbar("Error", "User not found in database");
        return;
      }

      // Navigate to User Home
      Get.offAll(() => const Home());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // SIGNUP
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      // Create Firebase account
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCred.user!.uid;

      // Save user data to Firestore
      await _firestore.collection(usersCollection).doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'role': 'user', // default role for users
        'imgUrl': "",
        'cart_count': "0",
        'wishlist_count': "0",
        'order_count': "0",
      });

      // Navigate to User Home
      Get.offAll(() => const Home());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Failed", e.message ?? "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // SIGNOUT
  Future<void> signout() async {
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }
}*/


import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/auth_screen/login_screen.dart';
import 'package:projects/views/home_screen/home.dart';
import 'package:projects/seller/views/seller_home_screen/seller_home.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ ROLE-BASED LOGIN
  Future<void> login() async {
    isLoading.value = true;

    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCred.user!.uid;

      // 🔥 SINGLE COLLECTION WITH ROLE
      final userDoc =
          await _firestore.collection(usersCollection).doc(uid).get();

      if (!userDoc.exists) {
        await _auth.signOut();
        Get.snackbar("Error", "Account not found");
        return;
      }

      final role = userDoc['role'];

      if (role == 'seller') {
        Get.offAll(() => SellerHome());
      } else if (role == 'user') {
        Get.offAll(() =>  Home());
      } else {
        Get.snackbar("Error", "Invalid role");
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

   // SIGNUP
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      // Create Firebase account
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCred.user!.uid;

      // Save user data to Firestore
      await _firestore.collection(usersCollection).doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'role': 'user', // default role for users
        'imgUrl': "",
        'cart_count': "0",
        'wishlist_count': "0",
        'order_count': "0",
      });

      // Navigate to User Home
      Get.offAll(() => Home());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Failed", e.message ?? "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }




   // SIGNOUT
  Future<void> signout() async {
    await _auth.signOut();
    Get.offAll(() =>  LoginScreen());
  }




}
