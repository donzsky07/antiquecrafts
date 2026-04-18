/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/firebase_const.dart';





class AnalyticsController extends GetxController {
  var totalOrders = 0.obs;
  var totalSales = 0.0.obs;
  var totalRatings = 0.0.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchAnalytics();
    super.onInit();
  }

  fetchAnalytics() async {
    isLoading(true);

    // 1️⃣ GET ALL ORDERS NA MAY vendor_id = current seller
    var ordersSnapshot = await firestore
        .collection(ordersCollection)
        .where("vendors", arrayContains: currentUser!.uid)
        .get();

    totalOrders.value = ordersSnapshot.docs.length;

    // 2️⃣ COMPUTE TOTAL SALES
    double sales = 0;
    for (var doc in ordersSnapshot.docs) {
      sales += double.tryParse(doc['total_amount'].toString()) ?? 0;
    }
    totalSales.value = sales;

    // 3️⃣ COMPUTE AVERAGE PRODUCT RATINGS
    var productSnapshot = await firestore
        .collection(productsCollection)
        .where("vendor_id", isEqualTo: currentUser!.uid)
        .get();

    double total = 0;
    int count = 0;

    for (var p in productSnapshot.docs) {
      if (p['p_ratings'] != null && p['p_ratings'] != "") {
        total += double.tryParse(p['p_ratings'].toString()) ?? 0;
        count++;
      }
    }

    totalRatings.value = count == 0 ? 0 : total / count;

    isLoading(false);
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/firebase_const.dart';

class AnalyticsController extends GetxController {

  var totalOrders = 0.obs;
  var totalSales = 0.0.obs;
  var totalRatings = 0.0.obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAnalytics();
    super.onInit();
  }

  void fetchAnalytics() {

    /// 🔹 ORDERS + SALES
    FirebaseFirestore.instance
        .collection(ordersCollection)
        .where("vendors", arrayContains: currentUser!.uid)
        .snapshots()
        .listen((orderSnapshot) {

      totalOrders.value = orderSnapshot.docs.length;

      double sales = 0;

      for (var doc in orderSnapshot.docs) {
        sales += (double.tryParse(doc['total_amount'].toString()) ?? 0);
      }

      totalSales.value = sales;
    });

    /// 🔹 RATINGS (PER VENDOR)
    FirebaseFirestore.instance
        .collection("ratings")
        .where("vendor_id", isEqualTo: currentUser!.uid)
        .snapshots()
        .listen((snapshot) {

      double sum = 0;

      for (var doc in snapshot.docs) {
        sum += (doc['rating'] as num).toDouble();
      }

      totalRatings.value =
          snapshot.docs.isEmpty ? 0 : sum / snapshot.docs.length;

      isLoading.value = false;
    });
  }
}