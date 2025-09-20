import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/cart_controller.dart';
import 'package:projects/services/firestore_services.dart';
import 'package:projects/widget/loading_indicator.dart';
import 'package:projects/widget/our_button.dart';

class CartScreen extends StatelessWidget{
  const CartScreen ({super.key});
  
  @override
  Widget build(BuildContext context){

    var controller = Get.put(CartController());
    return  Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getcart(currentUser!.uid),

        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }else if(snapshot.data!.docs.isEmpty){
            return Center(
              child: "Cart is Empty".text.color(darkFontGrey).make(),
            );
          }else {
            var data = snapshot.data!.docs;
            controller.calculate(data);

            return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.network("${data[index]['img']}"),
                      title: "${data[index]['title']} (x${data[index]['qty']})"
                      .text
                      .fontFamily(semibold)
                      .size(20)
                      .make(),
                      subtitle: "${data[index]['tprice']}"
                      .numCurrency
                      .text.color(redColor)
                      .size(18)
                      .fontFamily(semibold)
                      .make(),
                    trailing: const Icon(
                      Icons.delete,
                      color: redColor,
                    ).onTap(() {
                      FirestoreServices.deleteDocument(data[index].id);
                    }),
                   );

                },
              ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                "Total price"
                .text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .make(),
              Obx(
                () => "${controller.totalP.value}" 
                  .numCurrency
                  .text
                  .fontFamily(semibold)
                  .color(redColor)
                  .make(),
                )

                
              ],
            )
            .box.padding(EdgeInsets.all(12))
            .color(lightGolden)
            .width(context.screenWidth - 60)
            .roundedSM
            .make(),

          10.heightBox,
          SizedBox(
            width: context.screenWidth - 60,
            child:   ourButton(
              color: softBlueGreen,
              onPress: (){},
              textColor: whiteColor,
              title: "Proceed to Shipping", 
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

}