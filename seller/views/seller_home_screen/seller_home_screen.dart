
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
}