import 'package:projects/consts/consts.dart';
import 'package:projects/consts/lists.dart';
import 'package:projects/controllers/cart_controller.dart';
import 'package:projects/views/home_screen/home.dart';
import 'package:projects/widget/loading_indicator.dart';
import 'package:projects/widget/our_button.dart';
import 'package:get/get.dart';


class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});


  @override
  Widget build(BuildContext context) {

    var controller = Get.find<CartController>();

    return Obx ( 
      () => Scaffold (
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: controller.placingOrder.value 
        ? Center (
             child: loadingIndicator(),
          
        )
      : ourButton(
          onPress: () async {
           await controller.placeMyOrder(
              orderPaymentMethod: paymentMethod[controller.paymentIndex.value], 
              totalAmount: controller.totalP.value );

              await controller.clearCart();
              VxToast.show(context, msg: "Order placed successfully");
              Get.offAll(Home());
          },
          color: softBlueGreen,
          textColor: whiteColor,
          title: "Place my Order",
        ),
      ),
      appBar: AppBar(
        title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),

      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx (
        () => Column(
          children: List.generate(paymentMethodImg.length, (index) {

            return GestureDetector(
              onTap: (){
                controller.changePaymentIndex(index);
              }, 
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.paymentIndex.value == index ?  softBlueGreen : Colors.transparent,
                  width: 4,
                )
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                   Image.asset(
                    paymentMethodImg[index],
                    width: double.infinity, 
                    height: 100, 
                    colorBlendMode: controller.paymentIndex.value == index ? BlendMode.darken : BlendMode.color,
                    color: controller.paymentIndex.value == index ? Colors.black.withAlpha(102) : Colors.transparent,
                    fit: BoxFit.cover ),
                   controller.paymentIndex.value == index ? Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    value: true, 
                   onChanged: (value) {},
                   ),
                   )
                  : Container(),

                 Positioned(
                  bottom: 10,
                  right: 10,
                  child:  paymentMethod[index].text.white.fontFamily(semibold).size(16).make(),
                 )
                  ],
              ),
            )
            );
            
          }),
        )
        ))
    )

    );

  }


}