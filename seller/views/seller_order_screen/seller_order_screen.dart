import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_orders_controller.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_order_screen/seller_order_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:intl/intl.dart' as intl;


class SellerOrdersScreen extends StatelessWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SellerOrdersController());

    return Scaffold(
      appBar: sAppbarWidget(orders),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return sLoadingIndicator();
          }else {

            var data = snapshot.data!.docs;

            return Padding (
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
          children: List.generate(data.length,(index) {
              
              var time = data[index]['order_date'].toDate();
              
              return ListTile(
               onTap: () {
                Get.to(() => SellerOrderDetails(data: data[index]));
               },
               tileColor: textFieldGrey,
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
               ),
               title: boldText(text: "${data[index]['order_code']}", color: purpleColor ),
               subtitle: Column(
                children: [
                  Row(
                    children:  [
                     const Icon(Icons.calendar_month, color: fontGrey),
                     10.widthBox,
                      boldText(text: intl.DateFormat().add_yMd().format(time), color: fontGrey),
                    ],
                  ),
                  Row(
                    children:  [
                     const Icon(Icons.payment, color: fontGrey),
                     10.widthBox,
                      boldText(text: unpaid, color: red),
                    ],
                  ),
                ],
              ),
              trailing: boldText(text: "₱ ${data[index]['total_amount']}", color: purpleColor, size: 16.0),
              ).box.margin(const EdgeInsets.only(bottom: 4)).make();
            }
          ),
          
          ),
        )
        );
          }
         
        },
      ),

     );


  }
}