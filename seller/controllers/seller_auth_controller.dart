/*import 'package:get/get.dart';
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
}*/

//new codes 
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/seller/views/seller_auth_screen/seller_login_screen.dart';

class SellerAuthController extends GetxController {
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// LOGIN SELLER
  Future<String?> loginSeller(String email, String password) async {
    isLoading.value = true;

    try {
      // 1️⃣ Firebase Auth Login
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCred.user!.uid;

      // 2️⃣ Get user data from Firestore
      final userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await _auth.signOut();
        return "User data not found.";
      }

      final data = userDoc.data()!;

      // 3️⃣ ROLE CHECK (seller only)
      if (data['role'] != 'seller') {
        await _auth.signOut();
        return "This account is not a seller.";
      }

      // 4️⃣ BLOCKED CHECK
      if (data['isBlocked'] == true) {
        await _auth.signOut();
        return "Your account is blocked.\nReason: ${data['blockedReason'] ?? ''}";
      }

      // 5️⃣ OPTIONAL: APPROVAL CHECK
      if (data['sellerStatus'] != null &&
          data['sellerStatus'] != 'approved') {
        await _auth.signOut();
        return "Your seller account is pending approval.";
      }

      return null; // ✅ SUCCESS
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// SIGNUP SELLER
  Future<void> signupSeller({
    required String name,
    required String email,
    required String password,
    required String storeName,
    required String phone,
  }) async {
    isLoading.value = true;

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,

        'role': 'seller',
        'storeName': storeName,
        'phone': phone,

        'cart_count': 0,
        'order_count': 0,
        'wishlist_count': 0,

        'isBlocked': false,
        'blockedReason': '',
        'blockedAt': null,

        // 🔥 optional approval system
        'sellerStatus': 'approved', // or "pending"

        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
  throw e.message ?? "Signup failed";
}
  }

  Future<void> logoutSeller() async {
  await _auth.signOut();
  Get.offAll(() => const SellerLoginScreen());
}
}
