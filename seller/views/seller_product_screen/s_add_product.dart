import 'package:projects/seller/consts/const.dart';
import 'package:get/get.dart';
import 'package:projects/seller/controllers/products_controller.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_dropdown.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_images.dart';
import 'package:projects/seller/views/seller_widgets/s_custom_textfield.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';


class SAddProduct extends StatelessWidget {
  const SAddProduct({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<SellerProductsController>();

    return Obx (
      () => Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
         leading: IconButton(onPressed: (){
          Get.back();
        },
        icon: Icon(Icons.arrow_back, color: white )),
        title: boldText(text: "Add Product", size: 18.0),
        actions: [
          controller.isloading.value 
          ? sLoadingIndicator(circleColor: white)
           : TextButton(
          onPressed: () async{
            controller.isloading(true);
            await controller.uploadImages();
            await controller.uploadProduct(context);
            Get.back();
        }, child: boldText(text: save, color: white, size: 18.0)),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sCustomTextField( hint: "eg. BMW ",label: "Product name", controller: controller.pnameController),
            10.heightBox,
            sCustomTextField(hint: "eg. Nice product", label: "Description", isDesc: true, controller: controller.pdescController),
            10.heightBox,
            sCustomTextField(hint: "eg. \$100", label: "Price", controller: controller.ppriceController),
            10.heightBox,
            sCustomTextField(hint: "eg. 20", label: "Quantity", controller: controller.pquantityController),
            
            10.heightBox,
            sProductDropdown("Category", controller.categoryList, controller.categoryvalue, controller),
            10.heightBox,
            sProductDropdown("Subcategory", controller.subcategoryList, controller.subcategoryvalue, controller ),
            10.heightBox,
            const Divider(color: white),
            boldText(text: "Choose product images"),
            10.heightBox,
            
            Obx (
              () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => controller.pImagesList[index] != null 
                ? Image.file(controller.pImagesList[index],
                  width: 100,
                ).onTap(() {
                  controller.pickImage(index, context);
                }) 
                : sProductImages(label: "${index + 1}").onTap((){
                  controller.pickImage(index, context);
                })
              ),
            ),
            ),
            5.heightBox,
            normalText(text: "First images will be your display image", color: lightGrey),
            const Divider(color: white),
            10.heightBox,
            boldText(text: "Choose product color"),
            10.heightBox,
            
            Obx(
              () => Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(
                9,
                (index) => Stack(
                  alignment: Alignment.center,
                  children: [
                    VxBox().color(Vx.randomPrimaryColor).roundedFull.size(50, 50).make().onTap((){
                      controller.selectedColorIndex.value = index;

                    }),
                    controller.selectedColorIndex.value == index ?
                    const Icon(Icons.done, color: white) : const SizedBox(),
                  ],
                  
                  ),
              )
            ),)
          ],
        ),
        ),
        ),
    )
    );
  

  }
}