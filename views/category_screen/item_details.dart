import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/product_controller.dart';
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

    var controller = Get.put(ProductController());
    controller.setProductPrice(int.parse(data['p_price'].toString()));
  controller.setInitialStock(int.parse(data['p_quantity'].toString()));

    return PopScope(
      canPop: true, 
      onPopInvokedWithResult: (didPop, result) {
        if(didPop) return;
        controller.resetValues();
       
      },
      child: Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            controller.resetValues();
            Get.back();
          }, 
          icon: const Icon(Icons.arrow_back) ),
        title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          Obx (
          () => IconButton(onPressed: () {
            if(controller.isFav.value){
              controller.removeFromWishlist(data.id, context);
            }else{
              controller.addToWishlist(data.id, context);
            }
          }, 
          icon: Icon(
            Icons.favorite_outlined,
            color: controller.isFav.value ? redColor : darkFontGrey,
            )),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //swiper section
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
                      }),

                      //title and details section  
                      10.heightBox,
                      title!.text.size(16).color(darkFontGrey).fontFamily(semibold).make(),
                      
                    10.heightBox,

"Rate this product".text
    .color(darkFontGrey)
    .fontFamily(semibold)
    .make(),

10.heightBox,

/// ⭐ CLICKABLE STARS
Obx(() => Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: List.generate(5, (index) {

    return IconButton(
      icon: Icon(
        Icons.star,
        size: 25,
        color: index < controller.rating.value
            ? golden
            : textfieldGrey,
      ),

      onPressed: () async {
        int ratingValue = index + 1;

        controller.rating.value = ratingValue;

        /// 1. SAVE RATING
        await FirebaseFirestore.instance
            .collection("ratings")
            .add({
          "product_id": data.id,
          "user_id": currentUser?.uid ?? "guest",
          "vendor_id": data['vendor_id'],
          "rating": ratingValue.toDouble(),
          "review": "",
          "isApproved": false,
          "isReported": false,
          "created_at": Timestamp.now(),
        });

        /// 2. UPDATE PRODUCT AVERAGE ⭐ (IMPORTANT FIX)
       DocumentReference productRef = FirebaseFirestore.instance
    .collection("products")
    .doc(data.id);

QuerySnapshot ratingSnap = await FirebaseFirestore.instance
    .collection("ratings")
    .where("product_id", isEqualTo: data.id)
    .get();

double sum = 0;

for (var doc in ratingSnap.docs) {
  sum += (doc['rating'] as num).toDouble();
}

int count = ratingSnap.docs.length;

double avg = count == 0 ? 0 : sum / count;

await productRef.update({
  "p_ratings": avg.toStringAsFixed(1),
  "totalRatings": count,
});
        VxToast.show(context, msg: "Rating submitted");
      },
    );
  }),
)),

                     
                     10.heightBox,
                     "${data['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(18).make(),

                     10.heightBox,

                     Row(
                      children :[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Seller".text.white.fontFamily(semibold).make(),
                            5.heightBox,
                            "${data['p_seller']}".text.fontFamily(semibold).color(darkFontGrey).size(16).make(),
                          ],
                        )),
                    
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.message_rounded, color: darkFontGrey),
                          ).onTap (() {
                            Get.to(
                              () => const ChatScreen(),
                              arguments: [data['p_seller'], data['vendor_id']],
                            
                            );
                          })

                      ],

                      ).box.height(60).padding(const EdgeInsets.symmetric(horizontal: 16)).color(textfieldGrey).make(),

                      //color section
                      20.heightBox,
                      Obx(
                        () => Column(
                       children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Color: ".text.color(textfieldGrey).make(),
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
                                    .color(Color(data['p_colors'][index]).withValues(alpha: 255))
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

                        //quantity row
Obx(
  () => Row(
    children: [
      SizedBox(
        width: 100,
        child: "Quantity: ".text.color(darkFontGrey).make(),
      ),
      // Decrease quantity
      Icon(Icons.remove).onTap(() async {
        if (controller.quantity.value > 0) {
          controller.quantity.value--;

          // Increase stock in Firestore
          await FirebaseFirestore.instance
              .collection('products')
              .doc(data.id)
              .update({'p_quantity': FieldValue.increment(1)});
        }
      }),
      5.widthBox,
      // Display quantity
      controller.quantity.value.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
      5.widthBox,
      // Increase quantity
      Icon(Icons.add).onTap(() async {
        // Get fresh stock
        DocumentSnapshot productSnap = await FirebaseFirestore.instance
            .collection('products')
            .doc(data.id)
            .get();

        int currentStock = productSnap['p_quantity'];

        if (currentStock > 0) {
          controller.quantity.value++;
          // Reduce stock in Firestore
          await FirebaseFirestore.instance
              .collection('products')
              .doc(data.id)
              .update({'p_quantity': FieldValue.increment(-1)});
        } else {
          VxToast.show(context, msg: "No more stock available");
        }
      }),
      10.widthBox,
      // Display remaining stock
      Obx(() => "Available: ${controller.remainingStock.value}".text.color(textfieldGrey).make()),
    ],
  ),
),
                       ], 

                      ),
                  
                      ).box.white.shadowSm.make(),

                      //description section
                      10.heightBox,

                      "Description".text.color(darkFontGrey).fontFamily(semibold).make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(darkFontGrey).make(),


                      //button section itemdetails buttonlist
                      10.heightBox,

                     /* ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          itemDetailsButtonList.length, 
                          (index) => ListTile(
                          title: (itemDetailsButtonList[index]).text.fontFamily(semibold).color(darkFontGrey).make(),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                        ),
                       ),*/
                       


                       10.heightBox,
                      //products you may like section
                      productsyoumaylike.text.fontFamily(bold).size(16).color(darkFontGrey).make(),
                      10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future:
                                    FirestoreServices.getFeaturedProducts(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return "No Featured Products"
                                        .text
                                        .white
                                        .makeCentered();
                                  } else {
                                    var featuredData = snapshot.data!.docs;

                                    return Row(
                                      children: List.generate(
                                        featuredData.length,
                                        (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              featuredData[index]['p_imgs'][0],
                                              width: 130,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                            10.heightBox,
                                            "${featuredData[index]['p_name']}"
                                                .text
                                                .fontFamily(semibold)
                                                .color(darkFontGrey)
                                                .make(),
                                            10.heightBox,
                                            "${featuredData[index]['p_price']}"
                                                .numCurrency
                                                .text
                                                .color(redColor)
                                                .fontFamily(bold)
                                                .size(16)
                                                .make()
                                          ],
                                        )
                                            .box
                                            .white
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 4))
                                            .roundedSM
                                            .padding(const EdgeInsets.all(8))
                                            .make()
                                            .onTap(() {
                                          Get.to(() => ItemDetails(
                                                title:
                                                    "${featuredData[index]['p_name']}",
                                                data: featuredData[index],
                                              ));
                                        }),
                                      ),
                                    );
                                  }
                                }),
                          ),
                    ],

              ),
              ),
            
           )),
SizedBox(
  width: double.infinity,
  height: 70,
  child: ourButton(
    color: softBlueGreen,
 onPress: () async {
  int qty = controller.quantity.value;
  int price = int.parse(data['p_price'].toString());

  if (qty <= 0) {
    VxToast.show(context, msg: "Minimum 1 product is required");
    return;
  }

  int total = price * qty; // ✅ direct compute

  await controller.addToCart(
    color: data['p_colors'][controller.colorIndex.value].toString(),
    context: context,
    vendorID: data['vendor_id'],
    img: data['p_imgs'][0],
    qty: qty,
    sellername: data['p_seller'],
    title: data['p_name'],
    tprice: total, // ✅ ALWAYS correct
    productId: data.id,
  );

  Get.to(() => CartScreen());

    },
    textColor: whiteColor,
    title: "Add to cart",
  ),
)
        ]
      ),
    ));
  }
}

