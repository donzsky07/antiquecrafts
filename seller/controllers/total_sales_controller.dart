import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalSalesController extends GetxController {
  var totalSales = 0.0.obs;
  var isLoading = false.obs;

  var orders = [].obs;

  final firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    try {
      isLoading(true);

      double sum = 0.0;
      List tempOrders = [];

      var snapshot = await firestore
          .collection('orders')
          .where('payment_status', isEqualTo: 'paid') // optional filter
          .get();

      for (var doc in snapshot.docs) {
        var data = doc.data();

        double amount = double.tryParse(
              data['total_amount'].toString(),
            ) ??
            0.0;

        sum += amount;

        tempOrders.add({
          'name': data['name'] ?? 'Unknown',
          'amount': amount,
          'status': data['status'] ?? '',
        });
      }

      orders.value = tempOrders;
      totalSales.value = sum;
    } catch (e) {
      // optional: debug
    } finally {
      isLoading(false);
    }
  }
}