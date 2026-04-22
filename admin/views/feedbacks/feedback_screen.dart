import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/admin/consts/const.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/widget/loading_indicator.dart';


class AdminFeedbackScreen extends StatelessWidget {
  const AdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "User Feedbacks".text.fontFamily(bold).make(),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("feedbacks") // ✅ FIXED
            .orderBy("created_at", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return "No feedback yet"
                .text
                .color(darkFontGrey)
                .makeCentered();
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];

              bool isApproved = item['isApproved'] ?? false;

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(item['user_id'])
                    .get(),

                builder: (context, userSnap) {
                  String userName = "Unknown User";

                  if (userSnap.hasData && userSnap.data!.exists) {
                    userName = userSnap.data!['name'] ?? "User";
                  }

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// USER INFO
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "User: $userName"
                                  .text
                                  .fontFamily(semibold)
                                  .make(),

                              isApproved
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.pending,
                                      color: Colors.orange),
                            ],
                          ),

                          10.heightBox,

                          /// REVIEW (FIXED)
                          "Review:"
                              .text
                              .fontFamily(semibold)
                              .make(),

                          5.heightBox,

                          "${item['review'] ?? ''}"
                              .text
                              .color(darkFontGrey)
                              .make(),

                          10.heightBox,

                          /// RATING
                          "Rating: ${item['rating'] ?? 0}"
                              .text
                              .color(selectedItemColor)
                              .make(),

                          10.heightBox,

                          /// PRODUCT INFO
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("products")
                                .doc(item['product_id'])
                                .get(),

                            builder: (context, productSnap) {
                              String productName = "Unknown Product";

                              if (productSnap.hasData &&
                                  productSnap.data!.exists) {
                                productName =
                                    productSnap.data!['p_name'] ?? "Product";
                              }

                              return "Product: $productName"
                                  .text
                                  .color(selectedItemColor)
                                  .make();
                            },
                          ),

                          10.heightBox,

                          /// ACTION BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              /// APPROVE / RESOLVE
                              TextButton.icon(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("feedbacks")
                                      .doc(item.id)
                                      .update({
                                    "isApproved": true,
                                    "status": "approved",
                                  });

                                  VxToast.show(context,
                                      msg: "Marked as approved");
                                },
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                label: "Approve"
                                    .text
                                    .color(Vx.green400)
                                    .make(),
                              ),

                              /// DELETE
                              IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("feedbacks")
                                      .doc(item.id)
                                      .delete();

                                  VxToast.show(context, msg: "Deleted");
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
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