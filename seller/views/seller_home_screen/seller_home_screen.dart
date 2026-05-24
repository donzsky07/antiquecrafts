
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/controllers/analytics_controller.dart';
import 'package:projects/seller/controllers/sort_controller.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/dashboard/seller_rating_screen.dart';
import 'package:projects/seller/views/dashboard/total_sales_screen.dart';
import 'package:projects/seller/views/seller_order_screen/seller_order_screen.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_screen.dart';
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

                /// DASHBOARD CLICKABLE
                Row(
                  children: [
                   Expanded(
  child: InkWell(
    onTap: () {
      Get.to(() => const SProductsScreen()); 
    },
    child: sDashboardButton(
      context,
      title: product,
      count: "${data.length}",
      icon: icProduct,
    ),
  ),
),
                    const SizedBox(width: 10),
                   Expanded(
  child: InkWell(
    onTap: () {
      Get.to(() => const SellerOrdersScreen());
    },
    child: Obx(() => sDashboardButton(
          context,
          title: orders,
          count: "${analyticsController.totalOrders.value}",
          icon: icOrders,
        )),
  ),
),
                  ],
                ),

                10.heightBox,

                Row(
                  children: [
                   Expanded(
  child: InkWell(
    onTap: () {
      Get.to(() => const SellerRatingsScreen());
    },
    child: Obx(() => sDashboardButton(
          context,
          title: rating,
          count: analyticsController.totalRatings.value.toStringAsFixed(1),
          icon: icStar,
        )),
  ),
),
                    const SizedBox(width: 10),
                Expanded(
  child: Obx(
    () => InkWell(
      onTap: () {
      
         Get.to(() => TotalSalesScreen());
      },
      child: sDashboardButton(
        context,
        title: totalSales,
        count:
            "₱ ${analyticsController.totalSales.value.toStringAsFixed(0)}",
        icon: icOrders,
      ),
    ),
  ),
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
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/controllers/analytics_controller.dart';
import 'package:projects/seller/controllers/sort_controller.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/dashboard/seller_rating_screen.dart';
import 'package:projects/seller/views/dashboard/total_sales_screen.dart';
import 'package:projects/seller/views/seller_order_screen/seller_order_screen.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_screen.dart';
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

    // 🔥 PESO FORMAT
    final pesoFormat = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sAppbarWidget(dashboard),

      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),

        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {

          if (!snapshot.hasData) {
            return sLoadingIndicator();
          }

          var data = snapshot.data!.docs;

          /// 🔥 DYNAMIC SORTING
          void applySorting() {

            if (sortController.selectedSort.value ==
                "Popular") {

              data.sort((a, b) {
                int aWish =
                    (a['p_wishlist'] ?? []).length;

                int bWish =
                    (b['p_wishlist'] ?? []).length;

                return bWish.compareTo(aWish);
              });
            }

            else if (sortController.selectedSort.value ==
                "A-Z") {

              data.sort((a, b) {

                String aName =
                    (a['p_name'] ?? '')
                        .toString()
                        .toLowerCase();

                String bName =
                    (b['p_name'] ?? '')
                        .toString()
                        .toLowerCase();

                return aName.compareTo(bName);
              });
            }

            else if (sortController.selectedSort.value ==
                "Newest") {

              data.sort((a, b) {

                Timestamp aDate =
                    a['p_date'] ?? Timestamp.now();

                Timestamp bDate =
                    b['p_date'] ?? Timestamp.now();

                return bDate.compareTo(aDate);
              });
            }
          }

          applySorting();

          return Padding(
            padding: const EdgeInsets.all(8.0),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// DASHBOARD BUTTONS
                Row(
                  children: [

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => const SProductsScreen(),
                          );
                        },

                        child: sDashboardButton(
                          context,
                          title: product,
                          count: "${data.length}",
                          icon: icProduct,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () =>
                                const SellerOrdersScreen(),
                          );
                        },

                        child: Obx(
                          () => sDashboardButton(
                            context,
                            title: orders,
                            count:
                                "${analyticsController.totalOrders.value}",
                            icon: icOrders,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                10.heightBox,

                Row(
                  children: [

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () =>
                                const SellerRatingsScreen(),
                          );
                        },

                        child: Obx(
                          () => sDashboardButton(
                            context,
                            title: rating,
                            count: analyticsController
                                .totalRatings.value
                                .toStringAsFixed(1),
                            icon: icStar,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Obx(
                        () => InkWell(
                          onTap: () {
                            Get.to(
                              () =>
                                  const TotalSalesScreen(),
                            );
                          },

                          child: sDashboardButton(
                            context,
                            title: totalSales,

                            // 🔥 FIXED PESO FORMAT
                            count:
                                "₱ ${pesoFormat.format(analyticsController.totalSales.value)}",

                            icon: icOrders,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                10.heightBox,
                const Divider(),

                /// SORT DROPDOWN
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    boldText(
                      text: "Products",
                      color: fontGrey,
                      size: 16.0,
                    ),

                    Obx(
                      () => DropdownButton<String>(
                        value:
                            sortController
                                .selectedSort.value,

                        items:
                            [
                              "Popular",
                              "A-Z",
                              "Newest",
                            ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),

                        onChanged: (value) {
                          if (value != null) {
                            sortController
                                .changeSort(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                20.heightBox,

                /// PRODUCT LIST
                Expanded(
                  child: Obx(() {

                    applySorting();

                    return ListView(
                      physics:
                          const BouncingScrollPhysics(),

                      children: List.generate(
                        data.length,
                        (index) {

                          var item = data[index];

                          double price =
                              double.tryParse(
                                    item['p_price']
                                        .toString(),
                                  ) ??
                                  0.0;

                          return ListTile(
                            onTap: () {
                              Get.to(
                                () => SProductDetails(
                                  data: item,
                                ),
                              );
                            },

                            leading: Image.network(
                              item['p_imgs'][0],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),

                            title: Text(
                              (item['p_name'] ?? '')
                                  .toString(),

                              style: const TextStyle(
                                color: fontGrey,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              "₱ ${pesoFormat.format(price)}",

                              style: const TextStyle(
                                color: darkGrey,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
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