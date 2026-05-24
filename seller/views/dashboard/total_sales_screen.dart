
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalSalesScreen extends StatelessWidget {
  const TotalSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // PESO FORMAT
    final pesoFormat = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Total Sales",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade900,

        iconTheme: const IconThemeData(
          color: Colors.white,
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
              child: Text(
                "No sales yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

              // SALES LIST
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
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.image,
                                        size: 35,
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

                                  const SizedBox(height: 6),

                                  // BUYER
                                  Text(
                                    "Buyer: ${data['order_by_name'] ?? 'Unknown'}",
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  // PAYMENT METHOD
                                  Text(
                                    "Payment Method: ${data['payment_method'] ?? 'N/A'}",
                                  ),

                                  const SizedBox(height: 6),

                                  // TOTAL
                                  Text(
                                    "Total: ₱ ${pesoFormat.format(orderTotal)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
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

              // TOTAL SALES BOTTOM
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    const Text(
                      "Overall Total Sales",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "₱ ${pesoFormat.format(totalSales)}",
                      style: const TextStyle(
                        fontSize: 28,
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