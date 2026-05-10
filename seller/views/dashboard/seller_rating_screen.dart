import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';

class SellerRatingsScreen extends StatelessWidget {
  const SellerRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sAppbarWidget(userRating),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ratings')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var ratings = snapshot.data!.docs;

          if (ratings.isEmpty) {
            return const Center(
              child: Text("No ratings yet"),
            );
          }

          return ListView.builder(
            itemCount: ratings.length,
            itemBuilder: (context, index) {

              var item = ratings[index];
              var data = item.data() as Map<String, dynamic>;

              // ratings collection fields
              String userId = data['user_id'] ?? "";
              String productId = data['product_id'] ?? "";

              return FutureBuilder(
                future: Future.wait([

                  // USER DATA
                  userId.isNotEmpty
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get()
                      : Future.value(null),

                  // PRODUCT DATA
                  productId.isNotEmpty
                      ? FirebaseFirestore.instance
                          .collection('products')
                          .doc(productId)
                          .get()
                      : Future.value(null),

                ]),

                builder: (context, AsyncSnapshot<List<dynamic>> snapshotData) {

                  String userName = "Anonymous";

                  String productName = "Unknown Product";

                  String productImage = "";

                  // USER
                  if (snapshotData.hasData &&
                      snapshotData.data![0] != null &&
                      snapshotData.data![0].exists) {

                    var userData =
                        snapshotData.data![0].data() as Map<String, dynamic>;

                    userName = userData['name'] ?? "Anonymous";
                  }

                  // PRODUCT
                  if (snapshotData.hasData &&
                      snapshotData.data![1] != null &&
                      snapshotData.data![1].exists) {

                    var productData =
                        snapshotData.data![1].data() as Map<String, dynamic>;

                    productName =
                        productData['p_name'] ?? "Unknown Product";

                    // if list ang images mo
                    if (productData['p_imgs'] != null &&
                        productData['p_imgs'].length > 0) {

                      productImage = productData['p_imgs'][0];
                    }
                  }

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(10),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // PRODUCT IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),

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
                                    child: const Icon(Icons.image),
                                  ),
                          ),

                          const SizedBox(width: 12),

                          // DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                // USER NAME
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // PRODUCT NAME
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // RATING
                                Text(
                                  "Rating: ${data['rating'] ?? 0} ⭐",
                                ),

                                const SizedBox(height: 4),

                                // REVIEW
                                Text(
                                  data['review'] ?? "No comment",
                                ),
                              ],
                            ),
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
    );
  }
}