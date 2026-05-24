import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';

class SProductDetails extends StatelessWidget {
  final dynamic data;
  const SProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {

    // 🔥 SAFE PARSING (FIXED)
    double rating =
        double.tryParse(data['p_ratings']?.toString() ?? '0') ?? 0.0;

    double price =
        double.tryParse(data['p_price']?.toString() ?? '0') ?? 0.0;

    int quantity =
        int.tryParse(data['p_quantity']?.toString() ?? '0') ?? 0;

    List images = data['p_imgs'] ?? [];
    List colors = data['p_colors'] ?? [];

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: darkGrey),
        ),
        title: boldText(
          text: "${data['p_name'] ?? ''}",
          color: fontGrey,
          size: 18.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 IMAGES
            VxSwiper.builder(
              autoPlay: true,
              height: 350,
              itemCount: images.length,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),

            10.heightBox,

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 NAME
                  boldText(
                    text: "${data['p_name'] ?? ''}",
                    color: fontGrey,
                    size: 18.0,
                  ),

                  10.heightBox,

                  /// 🔹 CATEGORY
                  Row(
                    children: [
                      boldText(
                        text: "${data['p_category'] ?? ''}",
                        color: fontGrey,
                        size: 16.0,
                      ),
                      10.widthBox,
                      normalText(
                        text: "${data['p_subcategory'] ?? ''}",
                        color: fontGrey,
                        size: 16.0,
                      ),
                    ],
                  ),

                  /// 🔹 RATING
                  10.heightBox,
                  Row(
                    children: [
                      VxRating(
                        isSelectable: false,
                        value: rating,
                        onRatingUpdate: (value) {},
                        normalColor: textFieldGrey,
                        selectionColor: golden,
                        count: 5,
                        maxRating: 5,
                        size: 25,
                      ),

                      10.widthBox,

                      normalText(
                        text: rating.toStringAsFixed(1),
                        color: fontGrey,
                      ),
                    ],
                  ),

                  /// 🔹 PRICE
                  10.heightBox,
                  boldText(
                    text: "₱ ${price.toStringAsFixed(2)}",
                    color: red,
                    size: 18.0,
                  ),

                  20.heightBox,

                  /// 🔹 COLOR + QUANTITY BOX
                  Column(
                    children: [

                      /// COLORS
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(
                              text: "Color",
                              color: fontGrey,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              colors.length,
                              (index) {
                                Color colorValue;

                                try {
                                  colorValue = Color(colors[index]);
                                } catch (e) {
                                  colorValue = Colors.grey;
                                }

                                return VxBox()
                                    .size(40, 40)
                                    .roundedFull
                                    .color(colorValue)
                                    .margin(const EdgeInsets.symmetric(horizontal: 4))
                                    .make();
                              },
                            ),
                          ),
                        ],
                      ),

                      10.heightBox,

                      /// QUANTITY
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(
                              text: "Quantity",
                              color: fontGrey,
                            ),
                          ),
                          normalText(
                            text: "$quantity",
                            color: fontGrey,
                          ),
                        ],
                      ),
                    ],
                  ).box.white.padding(const EdgeInsets.all(8)).make(),

                  const Divider(),

                  20.heightBox,

                  /// 🔹 DESCRIPTION
                  boldText(
                    text: "Description",
                    color: fontGrey,
                  ),

                  10.heightBox,

                  normalText(
                    text: "${data['p_desc'] ?? ''}",
                    color: fontGrey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}