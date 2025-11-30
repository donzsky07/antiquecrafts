import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerAuthController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String?> loginSeller(String email, String password) async {
    try {
      // Step 1 — Firebase login
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCred.user!.uid;

      // Step 2 — Get vendor Firestore document
      final vendorDoc = await _firestore
          .collection('vendors')
          .where('id', isEqualTo: uid)
          .get();

      if (vendorDoc.docs.isEmpty) {
        return "Your account is not registered as vendor.";
      }

      return null; // SUCCESS
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logoutSeller() => _auth.signOut();
}
