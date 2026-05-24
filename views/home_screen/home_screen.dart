import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/consts/lists.dart';
import 'package:projects/controllers/home_controller.dart';
import 'package:projects/services/firestore_services.dart';
import 'package:projects/views/category_screen/flashsale_screen.dart';
import 'package:projects/views/category_screen/item_details.dart';
import 'package:projects/views/category_screen/todays_deal.dart';
import 'package:projects/views/category_screen/top_brand.dart';
import 'package:projects/views/category_screen/top_categories.dart';
import 'package:projects/views/category_screen/top_seller.dart';
import 'package:projects/views/home_screen/components/featured_category_page.dart';
import 'package:projects/views/home_screen/components/historical_screen.dart';
import 'package:projects/widget/home_button.dart';
import 'package:projects/views/home_screen/components/featured_button.dart';
import 'package:projects/widget/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            // SEARCH FIELD + LIVE RESULTS
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  color: lightGrey,
                  child: TextFormField(
                    controller: controller.searchController,
                    onChanged: (value) {
                      controller.searchProducts(value); // Live search
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: whiteColor,
                      hintText: searchanything,
                      hintStyle: TextStyle(color: textfieldGrey),
                    ),
                  ),
                ),
                5.heightBox,
                Obx(() {
                  if (controller.searchResults.isEmpty ||
                      controller.searchController.text.isEmpty) {
                    return Container();
                  } else {
                    return Container(
                      color: whiteColor,
                      constraints: BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          var product = controller.searchResults[index];
                          return ListTile(
                            leading: Image.network(
                              product['p_imgs'][0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product['p_name']),
                            subtitle: Text(
                               "${product['p_category']} - ₱${(product['p_price'] as num? ?? 0).toDouble().toStringAsFixed(2)}"),
                            onTap: () {
                              Get.to(() => ItemDetails(
                                    title: product['p_name'],
                                    data: product,
                                  ));
                            },
                          );
                        },
                      ),
                    );
                  }
                }),
              ],
            ),

            10.heightBox,

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    
                    // FIRST SWIPER
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            slidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),
                    10.heightBox,

                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: List.generate(
    2,
    (index) => InkWell(
      onTap: () {
        if (index == 0) {
     
          Get.to(() => TodaysDealScreen());
        } else {
       
           Get.to(() => FlashSaleScreen());
        }
      },
      child: homeButton(
        height: context.screenHeight * 0.15,
        width: context.screenWidth / 2.5,
        icon: index == 0 ? icTodaysDeal : icFlashDeal,
        title: index == 0 ? todayDeal : flashsale,
      ),
    ),
  ),
),

                    // SECOND SWIPER
                    10.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSlidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),

                   // CATEGORY BUTTONS
10.heightBox,
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: List.generate(
    3,
    (index) => InkWell(
     onTap: () {
  if (index == 0) {
   Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) => const TopCategoriesScreen(
        categoryName: "Handwoven",
      ),
    ),
);
  } else if (index == 1) {Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TopBrandScreen(
      brandName: "TechCare",
    ),
  ),
);
  } else {Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TopSellerScreen(
      sellerId: "rsKYOv84Xmdufari9kAMxX7IChR2",
      sellerName: "TechCare",
    ),
  ),
);
  }
},
      child: homeButton(
        height: context.screenHeight * 0.15,
        width: context.screenWidth / 3.5,
        icon: index == 0
            ? icTopCategories
            : index == 1
                ? icBrands
                : icTopSeller,
        title: index == 0
            ? topCategories
            : index == 1
                ? topBrand
                : topSellers,
      ),
    ),
  ),
),

                    // FEATURED CATEGORIES

                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              featuredButton(
  icon: featuredImages1[index],
  title: featuredTitles1[index],
).onTap(() {
  Get.to(() => FeaturedCategoryPage(
        category: featuredTitles1[index],
      ));
}),
                              10.heightBox,
                            featuredButton(
  icon: featuredImages2[index],
  title: featuredTitles2[index],
).onTap(() {
  Get.to(() => FeaturedCategoryPage(
        category: featuredTitles2[index],
      ));
}),
                            ],
                          ),
                        ).toList(),
                      ),
                    ),

                  //HISTORICAL BACKGROUND
                  // HISTORICAL BACKGROUND BUTTON
20.heightBox,

GestureDetector(
  onTap: () {
    Get.to(() => const HistoricalBackgroundScreen());
  },
  child: Container(
    padding: const EdgeInsets.all(15),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.brown.shade400,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [

        const Icon(
          Icons.history_edu,
          color: Colors.white,
          size: 35,
        ),

        15.widthBox,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              Text(
                "Historical Background",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Learn the story behind Antique Crafts products.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),


                    // FEATURED PRODUCTS
                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: softBlueGreen),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
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
    (index) => Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE + FEATURED BADGE
          Stack(
            children: [
              Image.network(
                featuredData[index]['p_imgs'][0],
                width: 160,
                height: 130,
                fit: BoxFit.cover,
              ),

              // ⭐ FEATURED BADGE
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "FEATURED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          8.heightBox,

          // NAME
          Text(
            featuredData[index]['p_name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: semibold,
              color: darkFontGrey,
            ),
          ),

          6.heightBox,

          // PRICE (FIXED FORMAT)
          Text(
            "₱${(featuredData[index]['p_price'] as num? ?? 0).toDouble().toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
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
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),

                  /*  // 3RD SWIPER
                    20.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSlidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),*/

                    // ALL PRODUCTS
                    20.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: allproducts.text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .size(18)
                          .make(),
                    ),
                    20.heightBox,
                    StreamBuilder(
                      stream: FirestoreServices.allproducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else {
                          var allproductsdata = snapshot.data!.docs;
                          return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allproductsdata.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      mainAxisExtent: 300),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      allproductsdata[index]['p_imgs'][0],
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    const Spacer(),
                                    10.heightBox,
                                    "${allproductsdata[index]['p_name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                   "₱${(allproductsdata[index]['p_price'] as num? ?? 0).toDouble().toStringAsFixed(2)}"
                                        .text
                                        .color(redColor)
                                        .fontFamily(bold)
                                        .size(16)
                                        .make(),
                                    10.heightBox,
                                  ],
                                )
                                    .box
                                    .white
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .roundedSM
                                    .padding(const EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  Get.to(() => ItemDetails(
                                        title:
                                            "${allproductsdata[index]['p_name']}",
                                        data: allproductsdata[index],
                                      ));
                                });
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}