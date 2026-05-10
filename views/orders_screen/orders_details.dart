
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/orders_screen/components/order_place_details.dart';
import 'package:projects/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatefulWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  State<OrdersDetails> createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {

  /// 🔥 MARK AS RECEIVED (OFFICIAL RECEIPT ACTION)
  Future<void> markAsReceived() async {
    await FirebaseFirestore.instance
        .collection(ordersCollection)
        .doc(widget.data.id)
        .update({
      "order_delivered": true,
      "order_on_delivery": false,
    });

    VxToast.show(context, msg: "Order received successfully");
    setState(() {});
  }

  int toInt(value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    return Scaffold(
      backgroundColor: whiteColor,

      /// 🔥 APPBAR
      appBar: AppBar(
        title: "Order Details"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              /// 🔥 ORDER STATUS (READ ONLY DISPLAY)
              orderStatus(
                color: redColor,
                icon: Icons.done,
                title: "Placed",
                showDone: data['order_placed'],
              ),
              orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Confirmed",
                showDone: data['order_confirmed'],
              ),
              orderStatus(
                color: Colors.orange,
                icon: Icons.car_crash,
                title: "On Delivery",
                showDone: data['order_on_delivery'],
              ),
              orderStatus(
                color: Colors.green,
                icon: Icons.done_all_rounded,
                title: "Delivered",
                showDone: data['order_delivered'],
              ),

              const Divider(),
              10.heightBox,

              /// 🔥 ORDER INFO
              Column(
                children: [
                  orderPlaceDetails(
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method",
                  ),
                  orderPlaceDetails(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format(data['order_date'].toDate()),
                    d2: data['payment_method'],
                    title1: "Order Date",
                    title2: "Payment Method",
                  ),
                  orderPlaceDetails(
                    d1: data['payment_method'] == "Cash on Delivery"
    ? (data['order_delivered'] == true ? "Paid" : "Unpaid")
    : "Paid",
                    d2: data['order_delivered'] == true
                        ? "Received"
                        : "Processing",
                    title1: "Payment Status",
                    title2: "Delivery Status",
                  ),
                ],
              ).box.outerShadowMd.white.make(),

              const Divider(),
              10.heightBox,

              /// 🔥 SHIPPING ADDRESS + TOTAL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// ADDRESS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Shipping Address"
                            .text
                            .fontFamily(semibold)
                            .make(),
                        "${data['order_by_name']}".text.make(),
                        "${data['order_by_address']}".text.make(),
                        "${data['order_by_city']}".text.make(),
                        "${data['order_by_phone']}".text.make(),
                      ],
                    ),

                    /// TOTAL
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Total Amount"
                              .text
                              .fontFamily(semibold)
                              .make(),
                        "₱${toInt(data['total_amount']).toDouble().toStringAsFixed(2)}"
    .text
    .color(redColor)
    .fontFamily(bold)
    .make(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),
              10.heightBox,

              /// 🔥 ORDERED PRODUCTS
              "Ordered Products"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),

              10.heightBox,

              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(data['orders'].length, (index) {
                  var item = data['orders'][index];

                  int qty = int.tryParse(item['qty'].toString()) ?? 0;
                  double price =
                      double.tryParse(item['tprice'].toString()) ?? 0.0;
                  double subtotal = qty * price;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: item['title'],
                        title2:
                           "$qty x ₱${price.toStringAsFixed(2)} = ₱${subtotal.toStringAsFixed(2)}",
                        d1: "",
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

              /// 🔥 RECEIVED BUTTON (ONLY IF NOT DELIVERED)
              if (data['order_delivered'] == false)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: markAsReceived,
                    child: const Text("I Received My Parcel"),
                  ),
                ),

              if (data['order_delivered'] == true)
                "✔ You have received this order"
                    .text
                    .color(green)
                    .fontFamily(semibold)
                    .makeCentered(),
            ],
          ),
        ),
      ),
    );
  }
}