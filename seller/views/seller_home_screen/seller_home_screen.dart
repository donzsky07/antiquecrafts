
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_dashboard_button.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: sAppbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return sLoadingIndicator();
          
          }else {
            var data = snapshot.data!.docs;

          data = data.sortedBy((a, b) {
  var aList = (a['p_wishlist'] ?? []) as List;
  var bList = (b['p_wishlist'] ?? []) as List;
  return aList.length.compareTo(bList.length);
});


            return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard buttons
             Row(
  children: [
    Expanded(child: sDashboardButton(context, title: product, count: "${data.length}", icon: icProduct)),
      const SizedBox(width: 10),
    Expanded(child: sDashboardButton(context, title: orders, count: "15", icon: icOrders)),
  ],
),

              10.heightBox,
            Row(
  children: [
    Expanded(child: sDashboardButton(context, title: rating, count: "60", icon: icStar)),
      const SizedBox(width: 10),
    Expanded(child: sDashboardButton(context, title: totalSales, count: "15", icon: icOrders)),
  ],
),

              10.heightBox,
              const Divider(),
              10.heightBox,
              boldText(text: popular, color: fontGrey, size: 16.0),
              
              20.heightBox,
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children :  List.generate(
                  data.length,
                  (index) =>((data[index]['p_wishlist'] ?? []) as List).isEmpty

                  ? const SizedBox()
                  : ListTile(
                    onTap: () {
                    Get.to(() => SProductDetails(data: data[index]));
                    },
                    leading: Image.network(
                      data[index]['p_imgs'][0],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: boldText(text: "${data[index]['p_name']}", color: fontGrey, size: 18.0),
                    subtitle: normalText(text: "₱ ${data[index]['p_price']}", color: darkGrey, size: 16.0),
                  ),
                ),
                  ),
                ),
            
            ],
          ),
        );
          }

        },)
      );
   
  }
}*/

//user_v5 edited//
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/controllers/analytics_controller.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_dashboard_button.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 INIT ANALYTICS CONTROLLER
    final analyticsController = Get.put(AnalyticsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sAppbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return sLoadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            // 🔹 Sort by wishlist count
            data = data.sortedBy((a, b) {
              var aList = (a['p_wishlist'] ?? []) as List;
              var bList = (b['p_wishlist'] ?? []) as List;
              return aList.length.compareTo(bList.length);
            });

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  /// 🔥 DASHBOARD CARDS
                  Row(
                    children: [
                      Expanded(
                        child: sDashboardButton(
                          context,
                          title: product,
                          count: "${data.length}",
                          icon: icProduct,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => sDashboardButton(
                              context,
                              title: orders,
                              count:
                                  "${analyticsController.totalOrders.value}",
                              icon: icOrders,
                            )),
                      ),
                    ],
                  ),

                  10.heightBox,

                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => sDashboardButton(
                              context,
                              title: rating,
                              count: analyticsController.totalRatings.value
                                  .toStringAsFixed(1),
                              icon: icStar,
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => sDashboardButton(
                              context,
                              title: totalSales,
                              count:
                                  "₱ ${analyticsController.totalSales.value.toStringAsFixed(0)}",
                              icon: icOrders,
                            )),
                      ),
                    ],
                  ),

                  10.heightBox,
                  const Divider(),
                  10.heightBox,

                  boldText(
                      text: popular, color: fontGrey, size: 16.0),

                  20.heightBox,

                  /// 🔥 POPULAR PRODUCTS LIST
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                        data.length,
                        (index) {
                          var wishlist =
                              (data[index]['p_wishlist'] ?? []) as List;

                          if (wishlist.isEmpty) {
                            return const SizedBox();
                          }

                          return ListTile(
                            onTap: () {
                              Get.to(() =>
                                  SProductDetails(data: data[index]));
                            },
                            leading: Image.network(
                              data[index]['p_imgs'][0],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            title: boldText(
                              text: "${data[index]['p_name']}",
                              color: fontGrey,
                              size: 18.0,
                            ),
                            subtitle: normalText(
                              text: "₱ ${data[index]['p_price']}",
                              color: darkGrey,
                              size: 16.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}*/

//start here

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/controllers/analytics_controller.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_dashboard_button.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsController = Get.put(AnalyticsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sAppbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (!snapshot.hasData) {
            return sLoadingIndicator();
          }

          var data = snapshot.data!.docs;

          // safe sort wishlist
          data = data.sortedBy((a, b) {
            var aList = (a['p_wishlist'] ?? []) as List;
            var bList = (b['p_wishlist'] ?? []) as List;
            return aList.length.compareTo(bList.length);
          });

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // DASHBOARD
                Row(
                  children: [
                    Expanded(
                      child: sDashboardButton(
                        context,
                        title: product,
                        count: "${data.length}",
                        icon: icProduct,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => sDashboardButton(
                            context,
                            title: orders,
                            count: "${analyticsController.totalOrders.value}",
                            icon: icOrders,
                          )),
                    ),
                  ],
                ),

                10.heightBox,

                Row(
                  children: [
                    Expanded(
                      child: Obx(() => sDashboardButton(
                            context,
                            title: rating,
                            count: analyticsController.totalRatings.value
                                .toStringAsFixed(1),
                            icon: icStar,
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => sDashboardButton(
                            context,
                            title: totalSales,
                            count:
                                "₱ ${analyticsController.totalSales.value.toStringAsFixed(0)}",
                            icon: icOrders,
                          )),
                    ),
                  ],
                ),

                10.heightBox,
                const Divider(),
                10.heightBox,

                boldText(text: popular, color: fontGrey, size: 16.0),

                20.heightBox,

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(data.length, (index) {
                      var item = data[index];

                      List wishlist = (item['p_wishlist'] ?? []) as List;

                      if (wishlist.isEmpty) {
                        return const SizedBox();
                      }

                      return ListTile(
                        onTap: () {
                          Get.to(() => SProductDetails(data: item));
                        },

                        leading: Image.network(
                          item['p_imgs'][0],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),

                        title: Text(
                          (item['p_name'] ?? '').toString(),
                          style: const TextStyle(
                            color: fontGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          "₱ ${(item['p_price'] ?? 0).toString()}",
                          style: const TextStyle(
                            color: darkGrey,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*/

//SECOND NEW CODES
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/controllers/analytics_controller.dart';
import 'package:projects/seller/controllers/sort_controller.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_dashboard_button.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsController = Get.put(AnalyticsController());
    final sortController = Get.put(SortController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sAppbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (!snapshot.hasData) {
            return sLoadingIndicator();
          }

          var data = snapshot.data!.docs;

          /// 🔥 DYNAMIC SORTING
          void applySorting() {
            if (sortController.selectedSort.value == "Popular") {
              data.sort((a, b) {
                int aWish = (a['p_wishlist'] ?? []).length;
                int bWish = (b['p_wishlist'] ?? []).length;
                return bWish.compareTo(aWish);
              });
            }

            else if (sortController.selectedSort.value == "A-Z") {
              data.sort((a, b) {
                String aName = (a['p_name'] ?? '').toString().toLowerCase();
                String bName = (b['p_name'] ?? '').toString().toLowerCase();
                return aName.compareTo(bName);
              });
            }

            else if (sortController.selectedSort.value == "Newest") {
              data.sort((a, b) {
                Timestamp aDate = a['p_date'] ?? Timestamp.now();
                Timestamp bDate = b['p_date'] ?? Timestamp.now();
                return bDate.compareTo(aDate);
              });
            }
          }

          applySorting();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// DASHBOARD
                Row(
                  children: [
                    Expanded(
                      child: sDashboardButton(
                        context,
                        title: product,
                        count: "${data.length}",
                        icon: icProduct,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => sDashboardButton(
                            context,
                            title: orders,
                            count: "${analyticsController.totalOrders.value}",
                            icon: icOrders,
                          )),
                    ),
                  ],
                ),

                10.heightBox,

                Row(
                  children: [
                    Expanded(
                      child: Obx(() => sDashboardButton(
                            context,
                            title: rating,
                            count: analyticsController.totalRatings.value
                                .toStringAsFixed(1),
                            icon: icStar,
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => sDashboardButton(
                            context,
                            title: totalSales,
                            count:
                                "₱ ${analyticsController.totalSales.value.toStringAsFixed(0)}",
                            icon: icOrders,
                          )),
                    ),
                  ],
                ),

                10.heightBox,
                const Divider(),

                /// 🔽 SORT DROPDOWN
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    boldText(text: "Products", color: fontGrey, size: 16.0),

                    Obx(() => DropdownButton<String>(
                          value: sortController.selectedSort.value,
                          items: ["Popular", "A-Z", "Newest"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              sortController.changeSort(value);
                            }
                          },
                        )),
                  ],
                ),

                20.heightBox,

                /// PRODUCT LIST
                Expanded(
                  child: Obx(() {
                    applySorting();

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(data.length, (index) {
                        var item = data[index];

                        double price = double.tryParse(
                                item['p_price'].toString()) ??
                            0.0;

                        return ListTile(
                          onTap: () {
                            Get.to(() => SProductDetails(data: item));
                          },

                          leading: Image.network(
                            item['p_imgs'][0],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),

                          title: Text(
                            (item['p_name'] ?? '').toString(),
                            style: const TextStyle(
                              color: fontGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            "₱ ${price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: darkGrey,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}