import 'package:projects/consts/consts.dart';
import 'package:projects/views/orders_screen/components/order_place_details.dart';
import 'package:projects/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;


class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  // ✅ helper function (VERY IMPORTANT)
  int toInt(value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
              // 🔥 ORDER STATUS
              orderStatus(
                  color: redColor,
                  icon: Icons.done,
                  title: "Placed",
                  showDone: data['order_placed']),
              orderStatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up,
                  title: "Confirmed",
                  showDone: data['order_confirmed']),
              orderStatus(
                  color: Colors.yellow,
                  icon: Icons.car_crash,
                  title: "On Delivery",
                  showDone: data['order_on_delivery']),
              orderStatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  title: "Delivered",
                  showDone: data['order_delivered']),

              const Divider(),
              10.heightBox,

              // 🔥 ORDER DETAILS
              Column(
                children: [
                orderPlaceDetails(
                  d1: data['order_code'], // random generated code
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
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status",
                  ),

                  // 🔥 ADDRESS + TOTAL
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Address
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),

                        // Total
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount"
                                  .text
                                  .fontFamily(semibold)
                                  .make(),

                              // ✅ SAFE TOTAL
                              toInt(data['total_amount'])
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),

              const Divider(),
              10.heightBox,

              // 🔥 ORDERED PRODUCTS
              "Ordered Products"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),

              10.heightBox,
ListView(
  physics: const NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  children: List.generate(data['orders'].length, (index) {
    var item = data['orders'][index];

    // ✅ Safe conversions
    int qty = int.tryParse(item['qty'].toString()) ?? 0;
    double price = double.tryParse(item['tprice'].toString()) ?? 0.0;
    double subtotal = qty * price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        orderPlaceDetails(
          title1: item['title'],
          title2: "$qty x ${price.numCurrency} = ${subtotal.numCurrency}",
          d1: "", // optional
          d2: "", // optional
        ),
        // 🔹 Color box if exists
        if (item.containsKey('color'))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 30,
              height: 10,
              color: Color(int.tryParse(item['color'].toString()) ?? 0),
            ),
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
    );
  }
}