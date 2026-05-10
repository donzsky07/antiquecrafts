/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/seller/controllers/total_sales_controller.dart';

class TotalSalesScreen extends StatelessWidget {
  TotalSalesScreen({super.key});

  final controller = Get.put(TotalSalesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final data = controller.orders[index];

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(data['name']),
                    subtitle: Text("Status: Paid / Delivered"),
                    trailing: Text(
                      "₱ ${data['amount'].toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            // 🔥 TOTAL SALES BOTTOM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Obx(() => Text(
                    "TOTAL SALES: ₱ ${controller.totalSales.value.toStringAsFixed(2)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        );
      }),
    );
  }
}*/


//NEW LINE OF CODES FIXED

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalSalesScreen extends StatelessWidget {
  const TotalSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
  backgroundColor: Colors.grey.shade100,
appBar: AppBar(
  title: const Text(
    "Total Sales",
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.grey.shade900,

  iconTheme: const IconThemeData(
    color: Colors.white, // back arrow color
  ),
),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('order_confirmed', isEqualTo: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
              child: Text("No sales yet"),
            );
          }

          double totalSales = 0;

          for (var item in orders) {

            var data = item.data() as Map<String, dynamic>;

            totalSales +=
                double.tryParse(
                  data['total_amount'].toString(),
                ) ??
                0;
          }

          return Column(
            children: [

              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,

                  itemBuilder: (context, index) {

                    var data =
                        orders[index].data() as Map<String, dynamic>;

                    double orderTotal =
                        double.tryParse(
                          data['total_amount'].toString(),
                        ) ??
                        0;

                    // PRODUCT DATA
                    String productName = "Product";
                    String productImage = "";

                    if (data['orders'] != null &&
                        data['orders'].length > 0) {

                      productName =
                          data['orders'][0]['title'] ?? "Product";

                      productImage =
                          data['orders'][0]['img'] ?? "";
                    }

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12),

                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            // PRODUCT IMAGE
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8),

                              child: productImage.isNotEmpty
                                  ? Image.network(
                                      productImage,
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 65,
                                      height: 65,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.image,
                                      ),
                                    ),
                            ),

                            const SizedBox(width: 12),

                            // DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  // PRODUCT NAME
                                  Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  // BUYER
                                  Text(
                                    "Buyer: ${data['order_by_name'] ?? 'Unknown'}",
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  // PAYMENT METHOD
                                  Text(
                                    "Payment Method: ${data['payment_method'] ?? ''}",
                                  ),

                                  const SizedBox(height: 5),

                                  // TOTAL
                                  Text(
                                 "Total: ₱ ${orderTotal.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // TOTAL SALES
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blueGrey.shade50,

                child: Column(
                  children: [

                    const Text(
                      "Overall Total Sales",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "₱ ${totalSales.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}