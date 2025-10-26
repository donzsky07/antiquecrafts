import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/auth_screen/login_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';



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

  //var userData ={}.obs;

   


 /* getUsername() async {
    var n = await firestore.collection(usersCollection).where('id', isEqualTo: currentUser!.uid).get().then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
    });

    username = n;*/

    /* var uid = currentUser!.uid;
     var doc = await firestore.collection(usersCollection).doc(uid).get();

    if (doc.exists) {
    userData.value = doc.data()!;
  }*/
//}
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
      debugPrint("🔥 Error loading user data: $e");
      username.value = 'Error';
    }
  }

   Future<void> signoutMethod() async {
    await auth.signOut();
    Get.delete<HomeController>();
    Get.offAll(() => const LoginScreen());
  }
}
 
 

 


