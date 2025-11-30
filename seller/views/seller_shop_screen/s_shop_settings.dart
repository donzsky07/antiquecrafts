import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_profile_controller.dart';
import 'package:projects/seller/views/seller_widgets/s_custom_textfield.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:projects/controllers/auth_controller.dart'; // ADD THIS

class SShopSettings extends StatefulWidget {
  const SShopSettings({super.key});

  @override
  State<SShopSettings> createState() => _SShopSettingsState();
}

class _SShopSettingsState extends State<SShopSettings> {
  late SellerProfileController controller;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SellerProfileController>();
    authController = Get.put(AuthController());

    // ✅ Load data ONLY once
    controller.loadShopData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: purpleColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: white),
            ),
            title: boldText(text: shopSettings, size: 18.0),
            actions: [
              controller.isloading.value
                  ? sLoadingIndicator(circleColor: white)
                  : TextButton(
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
                      child: normalText(text: save, color: white, size: 18.0),
                    ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                sCustomTextField(
                    label: shopName,
                    hint: nameHint,
                    controller: controller.shopNameController),
                10.heightBox,
                sCustomTextField(
                    label: address,
                    hint: shopAddressHint,
                    controller: controller.shopAddressController),
                10.heightBox,
                sCustomTextField(
                    label: mobile,
                    hint: shopMobileHint,
                    controller: controller.shopMobileController),
                10.heightBox,
                sCustomTextField(
                    label: website,
                    hint: shopWebsiteHint,
                    controller: controller.shopWebsiteController),
                10.heightBox,
                sCustomTextField(
                    isDesc: true,
                    label: description,
                    hint: shopDescHint,
                    controller: controller.shopDescController),
                20.heightBox,
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: white, fontSize: 16),
                  ),
                  onPressed: () async {
                    await authController.signoutMethod();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

