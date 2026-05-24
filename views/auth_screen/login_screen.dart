
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/views/auth_screen/signup_screen.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,

              "Log in to $appname"
                  .text
                  .fontFamily(bold)
                  .black
                  .size(22)
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

                    /// 🔥 LOGIN BUTTON WITH LOADING
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

                              await controller.login();
                            },
                          ).box.width(context.screenWidth - 50).make(),

                    15.heightBox,

                    /// SIGNUP TEXT
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,

                    /// SIGNUP BUTTON
                    ourButton(
                      color: lightGolden,
                      title: signup,
                      textColor: redColor,
                      onPress: () {
                        Get.to(() => const SignupScreen());
                      },
                    ).box.width(context.screenWidth - 50).make(),
                  ],
                ),
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}