
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects/views/auth_screen/login_screen.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

  // Text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // LOGIN
  Future<UserCredential?> loginMethod() async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? "Login failed");
    }
  }

  // SIGNUP
  Future<UserCredential?> signupMethod({
    required String email,
    required String password,
  }) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? "Signup failed");
    }
  }

  // SAVE USER DATA
 Future<void> storeUserData({
  required String name,
  required String email,
  required String uid,
}) async {
  try {
    await firestore.collection(usersCollection).doc(uid).set({
      'id': uid,
      'name': name,
      'email': email,
      'role': 'user',         // 👈 DEFAULT ROLE
      'imgUrl': "",
      'cart_count': "0",
      'wishlist_count': "0",
      'order_count': "0",
    });
  } catch (e) {
    Get.log("Error saving user data: $e");
    rethrow;
  }
}

  // SIGNOUT
  Future<void> signoutMethod() async {
    await auth.signOut();
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAll(() => const LoginScreen());
  }

// reactive variables
var loginAttempts = 0.obs;
var isLocked = false.obs;
var lockEndTime = DateTime.now().obs;



}

