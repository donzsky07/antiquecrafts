
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/product_controller.dart';
import 'package:projects/controllers/feedback_controller.dart';
import 'package:projects/views/cart_screen/cart_screen.dart';
import 'package:projects/views/chat_screen/chat_screen.dart';
import 'package:projects/widget/our_button.dart';
import 'package:projects/widget/loading_indicator.dart';
import 'package:projects/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {

    final ProductController controller = Get.find();
    var feedbackController = Get.put(FeedbackController());
    final textController = TextEditingController();

    controller.setProductPrice(int.parse(data['p_price'].toString()));
    controller.listenToStock(data.id);


    final price = data['p_price'];
    final discount = data['product_discount'];

   Text(
  "₱${price - (price * discount ~/ 100)}",
);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.resetValues();
      },
      child: Scaffold(
        backgroundColor: lightGrey,

        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            Obx(() => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishlist(data.id, context);
                    } else {
                      controller.addToWishlist(data.id, context);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  ),
                )),
          ],
        ),

        body: Column(
          children: [

            /// MAIN CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// IMAGES
                      VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        itemCount: data['p_imgs'].length,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data['p_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),

                      10.heightBox,
                      title!.text.size(20).color(darkFontGrey).fontFamily(semibold).make(),


                      10.heightBox,
                     "₱${double.parse(data['p_price'].toString()).toStringAsFixed(2)}"
    .text
    .color(redColor)
    .fontFamily(bold)
    .size(18)
    .make(),


                      10.heightBox,

                      /// SELLER
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Seller".text.size(17).white.fontFamily(semibold).make(),
                                5.heightBox,
                                "${data['p_seller']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.message_rounded, color: darkFontGrey),
                          ).onTap(() {
                            Get.to(() => const ChatScreen(),
                                arguments: [data['p_seller'], data['vendor_id']]);
                          }),
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),

                      20.heightBox,

                      /// COLOR + QUANTITY
                      Obx(() => Column(
                        children: [

                          /// COLOR
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Color: ".text.color(darkFontGrey).make(),
                              ),
                              Row(
                                children: List.generate(
                                  data['p_colors'].length,
                                  (index) => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]).withValues(alpha: 1.0))
                                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                                          .make()
                                          .onTap(() {
                                        controller.changeColorIndex(index);
                                      }),
                                      Visibility(
                                        visible: index == controller.colorIndex.value,
                                        child: const Icon(Icons.done, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          /// QUANTITY
                          Obx(() => Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity: ".text.color(darkFontGrey).make(),
                              ),

                              Icon(Icons.remove).onTap(() async {
                                if (controller.quantity.value > 0) {
                                  controller.quantity.value--;
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(data.id)
                                      .update({'p_quantity': FieldValue.increment(1)});
                                }
                              }),

                              5.widthBox,

                              controller.quantity.value.text
                                  .size(16)
                                  .color(darkFontGrey)
                                  .fontFamily(bold)
                                  .make(),

                              5.widthBox,

                              Icon(Icons.add).onTap(() async {

                                DocumentSnapshot productSnap =
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(data.id)
                                        .get();

                                int currentStock = productSnap['p_quantity'];

                                if (currentStock > 0) {
                                  controller.quantity.value++;
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(data.id)
                                      .update({'p_quantity': FieldValue.increment(-1)});
                                } else {
                                  VxToast.show(context, msg: "No more stock available");
                                }
                              }),

                              10.widthBox,

                              Obx(() => "Available: ${controller.remainingStock.value}"
                                  .text
                                  .color(darkFontGrey)
                                  .make()),
                            ],
                          )),
                        ],
                      )).box.white.shadowSm.make(),

                      10.heightBox,

                      /// DESCRIPTION
                      "Description".text.size(18).color(darkFontGrey).fontFamily(semibold).make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(darkFontGrey).make(),


// ⭐ RATING
10.heightBox,
"Rate Product".text.size(18).make(),
5.heightBox,

Obx(() => Row(
  children: List.generate(5, (index) {
    return IconButton(
      onPressed: () {
        feedbackController.selectedRating.value = index + 1.0;
      },
      icon: Icon(
        Icons.star,
        color: feedbackController.selectedRating.value > index
            ? Colors.amber
            : Colors.grey,
      ),
    );
  }),
)),

10.heightBox,

// 📝 REVIEW
TextField(
  controller: textController,
  maxLines: 3,
  decoration: const InputDecoration(
    hintText: "Write your feedback here...",
    border: OutlineInputBorder(),
  ),
),

10.heightBox,

// 🚀 SUBMIT BUTTON
Obx(() => feedbackController.isLoading.value
    ? loadingIndicator()
    : ourButton(
        color: redColor,
        textColor: whiteColor,
        title: "Submit Feedback",
        onPress: () async {

          // ✅ VALIDATION
          if (feedbackController.selectedRating.value == 0) {
            VxToast.show(context, msg: "Please select rating");
            return;
          }

          if (textController.text.trim().isEmpty) {
            VxToast.show(context, msg: "Please enter feedback");
            return;
          }

          try {
            feedbackController.isLoading(true);

            await feedbackController.submitFeedback(
              userId: currentUser!.uid, // ⚠️ make sure meron ka nito
              productId: data.id,
              vendorId: data['vendor_id'], // ⚠️ check if exists sa product
              rating: feedbackController.selectedRating.value,
              review: textController.text.trim(),
            );

            textController.clear();
            feedbackController.selectedRating.value = 0;

            VxToast.show(context, msg: "Feedback submitted!");

          } catch (e) {
            VxToast.show(context, msg: e.toString());
          } finally {
            feedbackController.isLoading(false);
          }
        },
      ),
),

                      10.heightBox,

                      /// FEATURED PRODUCTS
                      productsyoumaylike.text.fontFamily(bold).make(),
                      10.heightBox,

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                          future: FirestoreServices.getFeaturedProducts(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (!snapshot.hasData) {
                              return Center(child: loadingIndicator());
                            }

                            var featuredData = snapshot.data!.docs;

                            return Row(
                              children: List.generate(
                                featuredData.length,
                                (index) => Column(
                                  children: [
                                    Image.network(
                                      featuredData[index]['p_imgs'][0],
                                      width: 130,
                                      height: 130,
                                    ),
                                    10.heightBox,
                                    "${featuredData[index]['p_name']}".text.make(),
                                   "₱${double.parse(featuredData[index]['p_price'].toString()).toStringAsFixed(2)}"
    .text
    .color(redColor)
    .make(),


                                  ],
                                )
                                    .box
                                    .white
                                    .margin(const EdgeInsets.symmetric(horizontal: 4))
                                    .roundedSM
                                    .padding(const EdgeInsets.all(8))
                                    .make()
                                    .onTap(() {
                                  Get.to(() => ItemDetails(
                                        title: "${featuredData[index]['p_name']}",
                                        data: featuredData[index],
                                      ));
                                }),
                              ),
                            );
                          },
                        ),
                      ),

                      20.heightBox,
                    ],
                  ),
                ),
              ),
            ),

            /// ADD TO CART
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ourButton(
                color: softBlueGreen,
                textColor: whiteColor,
                title: "Add to cart",
                onPress: () async {

  int qty = controller.quantity.value;

  int price = int.parse(data['p_price'].toString());
  int discount = int.parse(data['product_discount'].toString());

  if (qty <= 0) {
    VxToast.show(context, msg: "Minimum 1 product is required");
    return;
  }

  // 🔥 COMPUTE DISCOUNTED PRICE
  int finalPrice = price - (price * discount ~/ 100);

  // 🔥 TOTAL BASED ON DISCOUNTED PRICE
  int total = finalPrice * qty;

  await controller.addToCart(
    color: data['p_colors'][controller.colorIndex.value].toString(),
    context: context,
    vendorID: data['vendor_id'],
    img: data['p_imgs'][0],
    qty: qty,
    sellername: data['p_seller'],
    title: data['p_name'],
    tprice: total,
    productId: data.id,
  );

  Get.to(() => CartScreen());
},
              ),
            )
          ],
        ),
      ),
    );
  }
}