import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RatingsPage extends StatelessWidget {
  const RatingsPage({super.key});

  // 🔥 GET PRODUCT NAME FROM product_id
  Future<String> getProductName(String productId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        return data?['p_name'] ?? 'Unknown Product';
      }
      return 'Unknown Product';
    } catch (e) {
      return 'Unknown Product';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🔥 HEADER WITH BACK BUTTON
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // OPTION 1: balik sa previous screen
                Get.back();

                // OPTION 2: diretso dashboard/home
                // Get.offAll(() => const DashboardScreen());
              },
            ),

            const Text(
              "Ratings & Reviews",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('ratings')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final ratings = snapshot.data!.docs;

              if (ratings.isEmpty) {
                return const Center(
                  child: Text("No ratings found"),
                );
              }

              return ListView.builder(
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final doc = ratings[index];
                  final data = doc.data();

                  final rating = data['rating'] ?? 0;
                  final review = data['review'] ?? '';
                  final userId = data['user_id'] ?? '';
                  final productId = data['product_id'] ?? '';

                  final isApproved = data['isApproved'] ?? false;
                  final isReported = data['isReported'] ?? false;

                  return FutureBuilder<String>(
                    future: getProductName(productId),
                    builder: (context, productSnap) {
                      final productName =
                          productSnap.data ?? "Loading...";

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text("⭐ $rating"),
                              const SizedBox(width: 10),

                              if (isApproved)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 18,
                                ),

                              if (isReported)
                                const Icon(
                                  Icons.flag,
                                  color: Colors.red,
                                  size: 18,
                                ),
                            ],
                          ),

                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Product: $productName"),
                              Text("User ID: $userId"),
                              const SizedBox(height: 5),
                              Text("Review: $review"),
                            ],
                          ),

                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'approve') {
                                FirebaseFirestore.instance
                                    .collection('ratings')
                                    .doc(doc.id)
                                    .update({
                                  'isApproved': true
                                });
                              }

                              if (value == 'report') {
                                FirebaseFirestore.instance
                                    .collection('ratings')
                                    .doc(doc.id)
                                    .update({
                                  'isReported': true
                                });
                              }

                              if (value == 'delete') {
                                Get.defaultDialog(
                                  title: "Delete Review?",
                                  middleText:
                                      "This cannot be undone.",
                                  textConfirm: "Delete",
                                  textCancel: "Cancel",
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    FirebaseFirestore.instance
                                        .collection('ratings')
                                        .doc(doc.id)
                                        .delete();

                                    Get.back();
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'approve',
                                child: Text("Approve"),
                              ),
                              PopupMenuItem(
                                value: 'report',
                                child: Text("Report"),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}