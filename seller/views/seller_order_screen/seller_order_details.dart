import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_orders_controller.dart';
import 'package:projects/seller/views/seller_order_screen/components/seller_order_place.dart';
import 'package:projects/seller/views/seller_widgets/s_our_button.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:intl/intl.dart' as intl;

class SellerOrderDetails extends StatefulWidget {
  final dynamic data;
  const SellerOrderDetails({super.key, this.data});

  @override
  State<SellerOrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<SellerOrderDetails> {
  var controller = Get.find<SellerOrdersController>();

  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);

    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: white,

          /// 🔥 APPBAR
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: darkGrey),
            ),
            title: boldText(
              text: "Order Details",
              color: fontGrey,
              size: 18.0,
            ),
          ),

          /// 🔥 CONFIRM BUTTON
          bottomNavigationBar: Visibility(
            visible: !controller.confirmed.value,
            child: SizedBox(
              height: 60,
              width: context.screenWidth,
              child: sOurButton(
                color: green,
                onPress: () {
                  controller.confirmed(true);
                  controller.changeStatus(
                    title: "order_confirmed",
                    status: true,
                    docID: widget.data.id,
                  );
                },
                title: "Confirm Order",
              ),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [

                  /// 🔥 STATUS BOX
                  Visibility(
                    visible: controller.confirmed.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        boldText(
                          text: "Order Status",
                          color: fontGrey,
                          size: 18.0,
                        ),

                        /// PLACED
                        SwitchListTile(
                          activeColor: green,
                          value: true,
                          onChanged: null,
                          title: boldText(text: "Placed", color: fontGrey),
                        ),

                        /// CONFIRMED
                        SwitchListTile(
                          activeColor: green,
                          value: controller.confirmed.value,
                          onChanged: null,
                          title: boldText(text: "Confirmed", color: fontGrey),
                        ),

                        /// 🚚 ON DELIVERY (SELLER CONTROL)
                        SwitchListTile(
                          activeColor: green,
                          value: controller.ondelivery.value,
                          onChanged: controller.delivered.value
                              ? null
                              : (value) {
                                  controller.ondelivery.value = value;

                                  controller.changeStatus(
                                    title: "order_on_delivery",
                                    status: value,
                                    docID: widget.data.id,
                                  );
                                },
                          title: boldText(
                              text: "On Delivery", color: fontGrey),
                        ),

                        /// ✅ DELIVERED (READ ONLY - USER CONTROL)
                        SwitchListTile(
                          activeColor: green,
                          value: controller.delivered.value,
                          onChanged: null,
                          title: boldText(
                            text: controller.delivered.value
                                ? "Received by Customer"
                                : "Waiting for Customer Confirmation",
                            color: fontGrey,
                          ),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(8))
                        .outerShadowMd
                        .white
                        .border(color: lightGrey)
                        .roundedSM
                        .make(),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 STATUS TEXT (CLEAR DISPLAY)
                  Text(
                    widget.data['order_delivered'] == true
                        ? "✔ Received by Customer"
                        : widget.data['order_on_delivery'] == true
                            ? "🚚 Out for Delivery"
                            : "📦 Processing",
                    style: TextStyle(
                      color: widget.data['order_delivered'] == true
                          ? green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 ORDER DETAILS
                  Column(
                    children: [
                      sellerOrderPlaceDetails(
                        d1: "${widget.data['order_code']}",
                        d2: "${widget.data['shipping_method']}",
                        title1: "Order Code",
                        title2: "Shipping Method",
                      ),
                      sellerOrderPlaceDetails(
                        d1: intl.DateFormat()
                            .add_yMd()
                            .format(widget.data['order_date'].toDate()),
                        d2: "${widget.data['payment_method']}",
                        title1: "Order Date",
                        title2: "Payment Method",
                      ),
                    sellerOrderPlaceDetails(
  d1: widget.data['order_delivered'] == true
      ? "Paid"
      : "Unpaid",

  d2: widget.data['order_delivered'] == true
      ? "Completed"
      : "In Progress",

  title1: "Payment Status",
  title2: "Delivery Status",
),

                      /// ADDRESS + TOTAL
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            /// ADDRESS
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                boldText(
                                    text: "Shipping Address",
                                    color: purpleColor),
                                "${widget.data['order_by_name']}"
                                    .text
                                    .make(),
                                "${widget.data['order_by_address']}"
                                    .text
                                    .make(),
                                "${widget.data['order_by_city']}"
                                    .text
                                    .make(),
                                "${widget.data['order_by_phone']}"
                                    .text
                                    .make(),
                              ],
                            ),

                            /// TOTAL
                            SizedBox(
                              width: 130,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  boldText(
                                      text: "Total Amount",
                                      color: purpleColor),
                                  boldText(
                                    text:
                                 "₱ ${(double.tryParse(widget.data['total_amount'].toString()) ?? 0).toStringAsFixed(2)}",
                                    color: red,
                                    size: 16.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .box
                      .outerShadowMd
                      .white
                      .border(color: lightGrey)
                      .roundedSM
                      .make(),

                  const Divider(),

                  10.heightBox,

                  /// 🔥 PRODUCTS
                  boldText(
                      text: "Ordered Products",
                      color: fontGrey,
                      size: 16.0),

                  10.heightBox,

                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        List.generate(controller.orders.length, (index) {
                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          sellerOrderPlaceDetails(
                            title1:
                                " ${controller.orders[index]['title']}",
                            title2:
                                "₱ ${(double.tryParse(controller.orders[index]['tprice'].toString()) ?? 0).toStringAsFixed(2)}",
                            d1:
                                "${controller.orders[index]['qty']}x",
                            d2: "",
                          ),
                          const Divider(),
                        ],
                      );
                    }),
                  )
                      .box
                      .outerShadowMd
                      .white
                      .margin(const EdgeInsets.only(bottom: 4))
                      .make(),

                  20.heightBox,
                ],
              ),
            ),
          ),
        ));
  }
}