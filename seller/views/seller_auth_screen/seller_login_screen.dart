
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/seller/controllers/seller_auth_controller.dart';
import 'package:projects/seller/views/seller_home_screen/seller_home.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class SellerLoginScreen extends StatelessWidget {
  const SellerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for seller login
    var controller = Get.put(SellerAuthController());

    // Text controllers
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: context.screenHeight * 0.1),
              applogoWidget(),
              const SizedBox(height: 10),
              "Seller Login to $appname"
                  .text
                  .fontFamily(bold)
                  .white
                  .size(22)
                  .make(),
              const SizedBox(height: 15),

              Obx(
                () => Column(
                  children: [
                    customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: emailController,
                    ),
                    customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: passwordController,
                    ),

                    const SizedBox(height: 10),

                    // Login button or loading
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(softBlueGreen),
                          )
                        : ourButton(
                            color: softBlueGreen,
                            title: login,
                            textColor: whiteColor,
                            onPress: () async {
                              controller.isLoading.value = true;

                              try {
                                String? result = await controller.loginSeller(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );

                                if (result == null) {
                                  // Login success
                                  Get.snackbar(
                                    "Success",
                                    "Welcome Seller!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Get.offAll(() => const SellerHome());
                                } else {
                                  // Error message from controller
                                  Get.snackbar(
                                    "Login Failed",
                                    result,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } catch (e) {
                                Get.snackbar(
                                  "Login Failed",
                                  e.toString(),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } finally {
                                controller.isLoading.value = false;
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
