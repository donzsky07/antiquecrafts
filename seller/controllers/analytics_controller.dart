import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//import 'package:seller_side/consts/const.dart';


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
}
