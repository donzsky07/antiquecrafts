import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SellerRatingsScreen extends StatelessWidget {
  const SellerRatingsScreen({super.key});

  // ⭐ STAR WIDGET
  Widget buildStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.purple,
        iconTheme:
            const IconThemeData(color: Colors.white),

        title: const Text(
          "Ratings & Feedbacks",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// BODY
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("feedbacks")
            .orderBy(
              "created_at",
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var feedbacks = snapshot.data!.docs;

          if (feedbacks.isEmpty) {
            return const Center(
              child: Text("No feedback yet"),
            );
          }

          return ListView.builder(
            itemCount: feedbacks.length,

            itemBuilder: (context, index) {

              var item = feedbacks[index];

              /// SAFE MAP FETCH
              Map<String, dynamic> data =
                  item.data() as Map<String, dynamic>;

              /// SAFE REVIEW FETCH
              String reviewText =
                  data['review']?.toString() ??
                  "No Review";

              /// SAFE RATING FETCH
              int rating =
                  (data['rating'] ?? 0).toInt();

              /// SAFE STATUS FETCH
              bool isApproved =
                  data['isApproved'] ?? false;

              return FutureBuilder(
                future: Future.wait([

                  /// USER FETCH
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(data['user_id'])
                      .get(),

                  /// PRODUCT FETCH
                  FirebaseFirestore.instance
                      .collection("products")
                      .doc(data['product_id'])
                      .get(),
                ]),

                builder: (context, AsyncSnapshot snap) {

                  String userName =
                      "Unknown User";

                  String productName =
                      "Unknown Product";

                  String productImage = "";

                  if (snap.hasData) {

                    /// USER DATA
                    var userDoc = snap.data[0];

                    if (userDoc.exists) {

                      Map<String, dynamic>
                          userData =
                          userDoc.data()
                              as Map<String, dynamic>;

                      userName =
                          userData['name'] ??
                          userData['username'] ??
                          "User";
                    }

                    /// PRODUCT DATA
                    var productDoc = snap.data[1];

                    if (productDoc.exists) {

                      Map<String, dynamic>
                          productData =
                          productDoc.data()
                              as Map<String, dynamic>;

                      productName =
                          productData['p_name'] ??
                          "Product";

                      if (productData['p_imgs'] !=
                              null &&
                          productData['p_imgs']
                              .isNotEmpty) {

                        productImage =
                            productData['p_imgs'][0];
                      }
                    }
                  }

                  return Card(
                    margin:
                        const EdgeInsets.all(10),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(12),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          /// USER INFO
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              Text(
                                "User: $userName",

                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),

                              isApproved
                                  ? const Icon(
                                      Icons
                                          .check_circle,
                                      color:
                                          Colors.green,
                                    )
                                  : const Icon(
                                      Icons.pending,
                                      color: Colors
                                          .orange,
                                    ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// REVIEW TITLE
                          const Text(
                            "Review:",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),

                          const SizedBox(height: 5),

                          /// REVIEW TEXT
                          Text(
                            reviewText,

                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// RATING
                          Row(
                            children: [

                              const Text(
                                "Rating:",

                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),

                              const SizedBox(width: 8),

                              buildStars(rating),
                            ],
                          ),

                          const SizedBox(height: 15),

                          /// PRODUCT INFO
                          Row(
                            children: [

                              /// PRODUCT IMAGE
                              ClipRRect(
                                borderRadius:
                                    BorderRadius
                                        .circular(10),

                                child:
                                    productImage
                                            .isNotEmpty
                                        ? Image.network(
                                            productImage,

                                            width: 70,
                                            height: 70,
                                            fit: BoxFit
                                                .cover,
                                          )
                                        : Container(
                                            width: 70,
                                            height: 70,

                                            color: Colors
                                                .grey
                                                .shade300,

                                            child:
                                                const Icon(
                                              Icons
                                                  .image,
                                            ),
                                          ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  productName,

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
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