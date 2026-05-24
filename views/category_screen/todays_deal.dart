import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/category_screen/item_details.dart';


class TodaysDealScreen extends StatelessWidget {
  const TodaysDealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: softBlueGreen,
  
      appBar: AppBar(
        backgroundColor: softBlueGreen,
        title: const Text("Today's Deals"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('product_discount', isGreaterThan: 0)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Deals Available"),
            );
          }

          final products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.70,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var data = products[index];

              final price = data['p_price'];
              final discount = data['product_discount'];

              final discountedPrice =
                  price - (price * discount ~/ 100);

              return InkWell(
                onTap: () {
                  Get.to(() => ItemDetails(
  title: data['p_name'],
  data: data,
));
                },

                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            data['p_imgs'][0],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NAME
                            Text(
                              data['p_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            // ORIGINAL PRICE
                            Text(
                              "₱$price",
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration:
                                    TextDecoration.lineThrough,
                              ),
                            ),

                            // DISCOUNTED PRICE
                            Text(
                              "₱$discountedPrice",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            // DISCOUNT LABEL
                            Text(
                              "$discount% OFF",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
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
          );
        },
      ),
    );
  }
}