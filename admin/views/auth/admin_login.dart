import 'package:get/get.dart';
import 'package:projects/admin/controllers/admin_authcontroller.dart';
import 'package:projects/admin/views/auth/admin_signup.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,

              "Admin Login"
                  .text
                  .fontFamily(bold)
                  .white
                  .size(22)
                  .make(),

              5.heightBox,

              "Sign in to admin dashboard"
                  .text
                  .gray400
                  .make(),

              15.heightBox,

              Obx(
                () => Column(
                  children: [
                    /// EMAIL
                    customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: controller.emailController,
                    ),

                    10.heightBox,

                    /// PASSWORD
                    customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: controller.passwordController,
                    ),

                    20.heightBox,

                    /// LOGIN BUTTON
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(softBlueGreen),
                          )
                        : ourButton(
                            color: softBlueGreen,
                            title: "Login as Admin",
                            textColor: whiteColor,
                            onPress: () async {
                              if (controller.emailController.text.isEmpty ||
                                  controller.passwordController.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all fields",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              await controller.loginAdmin();
                            },
                          ).box.width(context.screenWidth - 50).make(),

                    15.heightBox,

                    /// SIGNUP TEXT
                    "Create admin account"
                        .text
                        .color(fontGrey)
                        .make(),

                    5.heightBox,

                    /// SIGNUP BUTTON
                    ourButton(
                      color: lightGolden,
                      title: "Sign Up",
                      textColor: redColor,
                      onPress: () {
                        Get.to(() => const AdminSignupScreen());
                      },
                    ).box.width(context.screenWidth - 50).make(),
                  ],
                ),
              )
                  .box
.white
.rounded
.padding(const EdgeInsets.all(20))
.width(400) // 🔥 fixed professional card size
.shadowSm
.make(),
            ],
          ),
        ),
      ),
    );
  }
}