import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerFeedbackScreen extends StatelessWidget {
  const SellerFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// BACKGROUND COLOR
      backgroundColor:
          const Color.fromRGBO(48, 176, 199, 1),

      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(48, 176, 199, 1),

        elevation: 0,

        iconTheme:
            const IconThemeData(color: Colors.white),

        title: const Text(
          "Customer Feedbacks",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

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
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No feedbacks yet",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,

            padding: const EdgeInsets.all(12),

            itemBuilder: (context, index) {

              var item = data[index];

              Map<String, dynamic> feedback =
                  item.data() as Map<String, dynamic>;

              /// REVIEW
              String review =
                  feedback['review']?.toString() ??
                  "No Feedback";

              /// RATING
              int rating =
                  (feedback['rating'] ?? 0).toInt();

              /// USER ID
              String userId =
                  feedback['user_id']?.toString() ??
                  "";

              /// PRODUCT ID
              String productId =
                  feedback['product_id']?.toString() ??
                  "";

              return FutureBuilder(
                future: Future.wait([

                  /// USER FETCH
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userId)
                      .get(),

                  /// PRODUCT FETCH
                  FirebaseFirestore.instance
                      .collection("products")
                      .doc(productId)
                      .get(),
                ]),

                builder: (context, AsyncSnapshot snap) {

                  String userName = "Customer";

                  String productName = "Product";

                  String productImage = "";

                  if (snap.hasData) {

                    /// USER DATA
                    var userDoc = snap.data[0];

                    if (userDoc.exists) {

                      Map<String, dynamic> userData =
                          userDoc.data()
                              as Map<String, dynamic>;

                      userName =
                          userData['name'] ??
                          userData['username'] ??
                          "Customer";
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
                    elevation: 4,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),

                    margin:
                        const EdgeInsets.only(bottom: 15),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          /// USER INFO
                          Row(
                            children: [

                              const CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(
                                        48,
                                        176,
                                        199,
                                        1),

                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    /// USER NAME
                                    Text(
                                      userName,

                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    /// USER ID
                                    Text(
                                      userId,

                                      style: TextStyle(
                                        color: Colors
                                            .grey
                                            .shade600,

                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                        .circular(12),

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

                          const SizedBox(height: 15),

                          /// STARS
                          Row(
                            children: List.generate(
                              5,
                              (starIndex) {

                                return Icon(
                                  starIndex < rating
                                      ? Icons.star
                                      : Icons
                                          .star_border,

                                  color: Colors.amber,
                                  size: 22,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// FEEDBACK BOX
                          Container(
                            width: double.infinity,

                            padding:
                                const EdgeInsets.all(
                                    14),

                            decoration: BoxDecoration(
                              color:
                                  Colors.grey.shade100,

                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                            ),

                            child: Text(
                              review,

                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.4,
                              ),
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