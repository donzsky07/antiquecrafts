/*import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/auth_screen/login_screen.dart';



class HomeController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();

  }
 

  var currentNavIndex = 0.obs;

  var username = "".obs;
  var email = "".obs;

  var featuredList = [];

  var searchController = TextEditingController();


    Future<void> getUsername() async {
    if (currentUser == null) {
      username.value = '';
      email.value = '';
      return;
    }

    try {
      var snapshot = await firestore
          .collection(usersCollection)
          .where('id', isEqualTo: currentUser!.uid)
          .get();

           if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.single.data();
        username.value = data['name'] ?? 'No Name';
        email.value = data['email'] ?? '';
      } else {
        username.value = 'Unknown User';
      }
    } catch (e) {
      debugPrint(" Error loading user data: $e");
      username.value = 'Error';
    }
  }

   Future<void> signoutMethod() async {
    await auth.signOut();
    Get.delete<HomeController>();
    Get.offAll(() => const LoginScreen());
  }
}*/
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/auth_screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  // Controllers
  var searchController = TextEditingController();

  // Observables
  var currentNavIndex = 0.obs;
  var username = "".obs;
  var email = "".obs;
  var featuredList = [];
  var searchResults = <dynamic>[].obs;

  // Firestore & Auth
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  // Get current user's name & email
  Future<void> getUsername() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      username.value = '';
      email.value = '';
      return;
    }

    try {
      var snapshot = await firestore
          .collection(usersCollection)
          .where('id', isEqualTo: currentUser.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.single.data();
        username.value = data['name'] ?? 'No Name';
        email.value = data['email'] ?? '';
      } else {
        username.value = 'Unknown User';
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
      username.value = 'Error';
    }
  }

  // Sign out method
  Future<void> signoutMethod() async {
    await auth.signOut();
    Get.delete<HomeController>();
    Get.offAll(() => const LoginScreen());
  }

  // Live search products by name, category, description, or price
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      List<dynamic> results = [];

      // Search by product name
      var nameSnapshot = await firestore
          .collection(productsCollection)
          .where('p_name', isGreaterThanOrEqualTo: query)
          .where('p_name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      results.addAll(nameSnapshot.docs.map((e) => e.data()));

      // Search by category
      var categorySnapshot = await firestore
          .collection(productsCollection)
          .where('p_category', isGreaterThanOrEqualTo: query)
          .where('p_category', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      results.addAll(categorySnapshot.docs.map((e) => e.data()));

      // Search by description
      var descSnapshot = await firestore
          .collection(productsCollection)
          .where('p_desc', isGreaterThanOrEqualTo: query)
          .where('p_desc', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      results.addAll(descSnapshot.docs.map((e) => e.data()));

      // Search by price if number
      double? priceQuery = double.tryParse(query);
      if (priceQuery != null) {
        var priceSnapshot = await firestore
            .collection(productsCollection)
            .where('p_price', isEqualTo: priceQuery)
            .get();
        results.addAll(priceSnapshot.docs.map((e) => e.data()));
      }

      // Remove duplicates
      searchResults.value = results.toSet().toList();
    } catch (e) {
      print("Search error: $e");
      searchResults.clear();
    }
  }
}
 
 

 


