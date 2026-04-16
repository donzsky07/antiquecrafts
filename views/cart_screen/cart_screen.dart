import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/cart_controller.dart';
import 'package:projects/services/firestore_services.dart';
import 'package:projects/views/cart_screen/shipping_screen.dart';
import 'package:projects/widget/loading_indicator.dart';
import 'package:projects/widget/our_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<int> getCurrentStock(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    if (!doc.exists) return 0;
    final data = doc.data() as Map<String, dynamic>;
    return data['p_quantity'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: Obx(() => SizedBox(
            height: 60,
            child: ourButton(
              color: softBlueGreen,
              onPress: controller.hasSelected()
                  ? () => Get.to(() => const ShippingDetails())
                  : null, // disable if nothing selected
              textColor: whiteColor,
              title: "Proceed to Order",
            ),
          )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getcart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(child: "Cart is Empty".text.color(darkFontGrey).make());
          } else {
            var data = snapshot.data!.docs;
            controller.productSnapshot = data; // update controller
            controller.recalcTotal();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // ✅ Select All Checkbox
                  Obx(() {
                    bool allSelected = controller.isAllSelected();
                    return Row(
                      children: [
                        Checkbox(
                          value: allSelected,
                          onChanged: (_) => controller.toggleSelectAll(),
                        ),
                        "Select All".text.fontFamily(semibold).make(),
                      ],
                    );
                  }),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var item = data[index];
                        int subtotal = controller.toInt(item['tprice']) *
                            controller.toInt(item['qty']);

                        return Obx(() {
                          bool isSelected = controller.selectedItems[item.id] ?? false;

                          return ListTile(
                            leading: Checkbox(
                              value: isSelected,
                              onChanged: (_) => controller.toggleSelection(item.id),
                            ),
                            title: "${item['title']}".text.fontFamily(semibold).size(18).make(),
                            subtitle: "${item['qty']} x ${item['tprice']} = ${subtotal.numCurrency}"
                                .text
                                .color(redColor)
                                .size(16)
                                .fontFamily(bold)
                                .make(),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Decrease qty
                                Icon(Icons.remove).onTap(() async {
                                  int qty = controller.toInt(item['qty']);
                                  if (qty > 1) {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(item['productId'])
                                        .update({'p_quantity': FieldValue.increment(1)});
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(item.id)
                                        .update({'qty': qty - 1});
                                  }
                                }),
                                5.widthBox,
                                "${item['qty']}".text.make(),
                                5.widthBox,
                                // Increase qty
                                Icon(Icons.add).onTap(() async {
                                  int currentStock = await getCurrentStock(item['productId']);
                                  if (currentStock > 0) {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(item['productId'])
                                        .update({'p_quantity': FieldValue.increment(-1)});
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(item.id)
                                        .update({'qty': controller.toInt(item['qty']) + 1});
                                  } else {
                                    VxToast.show(context, msg: "No more stock available");
                                  }
                                }),
                                10.widthBox,
                                // Delete item
                                Icon(Icons.delete, color: redColor).onTap(() async {
                                  int qtyToRestore = controller.toInt(item['qty']);
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(item['productId'])
                                      .update({'p_quantity': FieldValue.increment(qtyToRestore)});
                                  FirestoreServices.deleteDocument(item.id);
                                }),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  10.heightBox,
                  // Total price of selected items
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Total price".text.fontFamily(semibold).color(darkFontGrey).make(),
                          "${controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor).make(),
                        ],
                      )
                          .box
                          .padding(EdgeInsets.all(12))
                          .color(lightGolden)
                          .width(context.screenWidth - 60)
                          .roundedSM
                          .make()),
                  10.heightBox,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}