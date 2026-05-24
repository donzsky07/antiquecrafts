/*import 'package:cloud_firestore/cloud_firestore.dart';
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
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';

class SellerRatingsScreen extends StatelessWidget {
  const SellerRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final sellerId =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: sAppbarWidget(userRating),

      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('vendor_id', isEqualTo: sellerId)
            .get(),

        builder: (context, productSnapshot) {

          // LOADING
          if (productSnapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (productSnapshot.hasError) {

            return Center(
              child: Text(
                "Error: ${productSnapshot.error}",
              ),
            );
          }

          // NO PRODUCTS
          if (!productSnapshot.hasData ||
              productSnapshot.data!.docs.isEmpty) {

            return const Center(
              child: Text(
                "No seller products found",
              ),
            );
          }

          // GET PRODUCT IDS
          List<String> sellerProductIds =
              productSnapshot.data!.docs
                  .map((e) => e.id)
                  .toList();

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ratings')
                .snapshots(),

            builder: (context, ratingSnapshot) {

              if (!ratingSnapshot.hasData) {

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var ratings = ratingSnapshot.data!.docs;

              // FILTER RATINGS
              var filteredRatings = ratings.where((r) {

                var data =
                    r.data() as Map<String, dynamic>;

                return sellerProductIds.contains(
                  data['product_id'],
                );

              }).toList();

              // EMPTY
              if (filteredRatings.isEmpty) {

                return const Center(
                  child: Text(
                    "No ratings found",
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredRatings.length,

                itemBuilder: (context, index) {

                  var ratingDoc =
                      filteredRatings[index];

                  var ratingData =
                      ratingDoc.data()
                          as Map<String, dynamic>;

                  return FutureBuilder(
                    future: Future.wait([

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(ratingData['user_id'])
                          .get(),

                      FirebaseFirestore.instance
                          .collection('products')
                          .doc(ratingData['product_id'])
                          .get(),

                    ]),

                    builder: (context,
                        AsyncSnapshot<List<dynamic>>
                            snapshot) {

                      if (!snapshot.hasData) {

                        return const SizedBox();
                      }

                      try {

                        var userDoc =
                            snapshot.data![0];

                        var productDoc =
                            snapshot.data![1];

                        var userData =
                            userDoc.data()
                                as Map<String, dynamic>;

                        var productData =
                            productDoc.data()
                                as Map<String, dynamic>;

                        String userName =
                            userData['name'] ??
                                "Anonymous";

                        String productName =
                            productData['p_name'] ??
                                "Unknown Product";

                        String image = "";

                        if (productData['p_imgs'] !=
                                null &&
                            productData['p_imgs']
                                .length > 0) {

                          image =
                              productData['p_imgs'][0];
                        }

                        return Card(
                          margin:
                              const EdgeInsets.all(8),

                          child: Padding(
                            padding:
                                const EdgeInsets.all(10),

                            child: Row(
                              children: [

                                // IMAGE
                                image.isNotEmpty
                                    ? Image.network(
                                        image,
                                        width: 70,
                                        height: 70,
                                        fit:
                                            BoxFit.cover,
                                      )
                                    : Container(
                                        width: 70,
                                        height: 70,
                                        color:
                                            Colors.grey,
                                      ),

                                const SizedBox(
                                    width: 10),

                                // DETAILS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        userName,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                          height: 4),

                                      Text(productName),

                                      const SizedBox(
                                          height: 4),

                                      Text(
                                        "Rating: ${ratingData['rating']} ⭐",
                                      ),

                                      const SizedBox(
                                          height: 4),

                                      Text(
                                        ratingData[
                                                'review'] ??
                                            "",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      } catch (e) {

                        return Padding(
                          padding:
                              const EdgeInsets.all(8),
                          child: Text(
                            "ERROR: $e",
                          ),
                        );
                      }
                    },
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