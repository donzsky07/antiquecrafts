import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_profile_controller.dart';
import 'package:projects/seller/views/seller_widgets/s_custom_textfield.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SShopSettings extends StatelessWidget {
  const SShopSettings({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<SellerProfileController>();

    return Obx (() => Scaffold(
      backgroundColor: purpleColor,
       appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
        icon: Icon(Icons.arrow_back, color: white),
      ),
      title: boldText(text: shopSettings, size: 18.0),
      actions: [
        
        controller.isloading.value 
        ? sLoadingIndicator(circleColor: white)
        :  TextButton(
          onPressed: () async {
            controller.isloading(true);
            await controller.updateShop(
              shopname: controller.shopNameController.text,
              shopaddress: controller.shopAddressController.text,
              shopmobile: controller.shopMobileController.text,
              shopwebsite: controller.shopWebsiteController.text,
              shopdesc: controller.shopDescController.text,
              );
              VxToast.show(context, msg: "Shop settings updated");
        }, 
        child: normalText(text: save, color: white, size:18.0))
      ],
     ),
     body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          sCustomTextField(
            label: shopName, 
            hint: nameHint,
            controller: controller.shopNameController
          ),
          10.heightBox,
          sCustomTextField(
            label: address, 
            hint: shopAddressHint,
            controller: controller.shopAddressController
          ),
          10.heightBox,
          sCustomTextField(
            label: mobile, 
            hint: shopMobileHint,
            controller: controller.shopMobileController
          ),
          10.heightBox,
          sCustomTextField(
            label: website, 
            hint: shopWebsiteHint,
            controller: controller.shopWebsiteController
          ),
          10.heightBox,
          sCustomTextField(
            isDesc: true,
            label: description,
            hint: shopDescHint,
            controller: controller.shopDescController
          ),
          

        ],
      ),
      ),

    )
  );
     


  }
}