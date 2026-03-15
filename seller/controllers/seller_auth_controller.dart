import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerAuthController extends GetxController {
  // Reactive loading state
  var isLoading = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Login seller with email and password
  /// Returns null if successful, otherwise returns error message
  Future<String?> loginSeller(String email, String password) async {
    isLoading.value = true;

    try {
      // 1️⃣ Firebase login
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCred.user!.uid;

      // 2️⃣ Check vendors collection
      final vendorDoc =
          await _firestore.collection('vendors').doc(uid).get();

      if (!vendorDoc.exists) {
        // Not a seller
        await _auth.signOut();
        return "Your account is not registered as a vendor.";
      }

      return null; // Login success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout seller
  Future<void> logoutSeller() async {
    await _auth.signOut();
  }
}
