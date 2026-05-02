/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/products_controller.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_product_screen/s_add_product.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';


class SProductsScreen extends StatelessWidget {
  const SProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SellerProductsController());

    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton(
      backgroundColor: purpleColor,
      shape: const CircleBorder(),
      onPressed: ()async{
        await controller.getCategories();
        controller.populateCategoryList();
        Get.to(() => const SAddProduct());
      }, 
      child: const Icon(Icons.add, color:white),
      ),
      appBar: sAppbarWidget(product),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
           if(!snapshot.hasData){
            return sLoadingIndicator();
          }else {
            var data = snapshot.data!.docs;

            return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
          children: List.generate(
            data.length,
            (index) => Card(
              child: ListTile(
                  onTap: () {
                    Get.to(() =>   SProductDetails(data: data[index]));
                  },
                leading: Image.network(data[index]['p_imgs'][0], width: 100, height: 100, fit: BoxFit.cover),
                title: boldText(text: "${data[index]['p_name']}", color: fontGrey ),
                subtitle: Row(
                  children: [
                    normalText(text: "₱ ${data[index]['p_price']}", color: darkGrey),
                    10.widthBox,
                    boldText(text: data[index]['is_featured'] == true ? "Featured" : "", color: green),
                  ],
                ),
                trailing: VxPopupMenu(
                  arrowSize: 0.0,
                  menuBuilder: () => Column(
                    children: List.generate(
                      popupMenuTitles.length, 
                      (i) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                      children: [
                        Icon(
                          popupMenuIcons[i],
                          color: data[index]['featured_id'] == currentUser!.uid && i == 0 
                          ? green : darkGrey ,
                          ),
                        10.widthBox,
                        normalText(text: data[index]['featured_id'] == currentUser!.uid && i == 0 
                        ? 'Remove_feature' 
                        : popupMenuTitles[i], color: darkGrey )
                      ],    
                  ).onTap (() {
                   switch (i) {
                    case 0 :
                       if(data[index]['is_featured'] == true) {
                      controller.removeFeatured(data[index].id);
                      VxToast.show(context, msg: "Remove");
                    }else{
                      controller.addFeatured(data[index].id);
                       VxToast.show(context, msg: "Added");
                    }

                    break;
                  case 1:
                    break;
                  case 2:
                    controller.removeProduct(data[index].id);
                    VxToast.show(context, msg: "Product Remove");
                    break;

                  default:
                   }
                  }),
                  ),
                  ),
                ).box.white.rounded.width(200).make(), 
                clickType: VxClickType.singleClick,
                child: Icon(Icons.more_vert_rounded)),

            ),

          ),
          
          ),
        )
        ),
      
       );

      }

      },
      ),
      
     
    );


  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/products_controller.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_product_screen/s_add_product.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_details.dart';
import 'package:projects/seller/views/seller_widgets/s_appbar_widget.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';

class SProductsScreen extends StatelessWidget {
  const SProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SellerProductsController());

    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        shape: const CircleBorder(),
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const SAddProduct());
        },
        child: const Icon(Icons.add, color: white),
      ),
      appBar: sAppbarWidget(product),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return sLoadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => Card(
                      child: ListTile(
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

                        // ✅ TITLE
                        title: boldText(
                            text: "${data[index]['p_name']}",
                            color: fontGrey),

                        // ✅ UPDATED SUBTITLE (WITH STOCK)
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            normalText(
                                text:
                                  "₱ ${(double.tryParse(data[index]['p_price'].toString()) ?? 0).toStringAsFixed(2)}",
                                color: darkGrey),
                            normalText(
                                text:
                                    "Stock: ${data[index]['p_quantity']}",
                                color: darkGrey),
                            boldText(
                              text: data[index]['is_featured'] ==
                                      true
                                  ? "Featured"
                                  : "",
                              color: green,
                            ),
                          ],
                        ),

                        // ✅ MENU
                     trailing: VxPopupMenu(
  arrowSize: 0.0,
  menuBuilder: () => Column(
    children: List.generate(
      popupMenuTitles.length,
      (i) {
        var product = data[index]; // ✅ para malinis

        bool isOwnerFeatured =
            product['is_featured'] == true &&
            product['featured_id'] == currentUser!.uid;

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                popupMenuIcons[i],
                color: isOwnerFeatured && i == 0
                    ? green
                    : darkGrey,
              ),
              10.widthBox,
              normalText(
                text: isOwnerFeatured && i == 0
                    ? 'Remove_feature'
                    : popupMenuTitles[i],
                color: darkGrey,
              ),
            ],
          ).onTap(() {
            switch (i) {

              // ⭐ FEATURE / REMOVE FEATURE
              case 0:
                if (product['is_featured'] == true &&
                    product['featured_id'] == currentUser!.uid) {
                  controller.removeFeatured(product.id);
                  VxToast.show(context, msg: "Removed");
                } else {
                  controller.addFeatured(product.id);
                  VxToast.show(context, msg: "Added");
                }
                break;

              // ✏️ EDIT PRODUCT
              case 1:
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController nameController =
                        TextEditingController(text: product['p_name']);

                    TextEditingController priceController =
                        TextEditingController(
                            text: product['p_price'].toString());

                    TextEditingController qtyController =
                        TextEditingController(
                            text: product['p_quantity'].toString());

                    return AlertDialog(
                      title: const Text("Update Product"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                labelText: "Product Name"),
                          ),
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Price"),
                          ),
                          TextField(
                            controller: qtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Stock"),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                priceController.text.isEmpty ||
                                qtyController.text.isEmpty) {
                              VxToast.show(context,
                                  msg: "All fields required");
                              return;
                            }

                            if (int.parse(qtyController.text) < 0) {
                              VxToast.show(context,
                                  msg: "Invalid stock");
                              return;
                            }

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(product.id)
                                .update({
                              'p_name': nameController.text,
                              'p_price': double.parse(
                                  priceController.text),
                              'p_quantity': int.parse(
                                  qtyController.text),
                            });

                            Navigator.pop(context);
                            VxToast.show(context,
                                msg: "Product Updated");
                          },
                          child: const Text("Update"),
                        ),
                      ],
                    );
                  },
                );
                break;

              // ❌ DELETE
              case 2:
                controller.removeProduct(product.id);
                VxToast.show(context,
                    msg: "Product Removed");
                break;

              default:
            }
          }),
        );
      },
    ),
  ).box.white.rounded.width(200).make(),
  clickType: VxClickType.singleClick,
  child: const Icon(Icons.more_vert_rounded),
),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}