import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects/consts/colors.dart';

class TopBrandScreen extends StatelessWidget {
  final String brandName;

  const TopBrandScreen({
    super.key,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: softBlueGreen,

      appBar: AppBar(
         backgroundColor: softBlueGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          brandName,
          style: const TextStyle(color: Colors.black),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('p_seller', isEqualTo: brandName)
            .snapshots(),

        builder: (context, snapshot) {

          // LOADING
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // EMPTY
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products found for this brand"),
            );
          }

          var products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {

              var data = products[index].data()
                  as Map<String, dynamic>;

              String image = "";

              if (data['p_imgs'] != null &&
                  data['p_imgs'].isNotEmpty) {
                image = data['p_imgs'][0];
              }

              return Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // PRODUCT IMAGE
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),

                        child: image.isNotEmpty
                            ? Image.network(
                                image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          // PRODUCT NAME
                          Text(
                            data['p_name'] ?? "No name",
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // PRICE
                          Text(
                            "₱${data['p_price'] ?? 0}",
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // SELLER NAME (optional display)
                          Text(
                            data['p_seller'] ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}