import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';
import 'package:projects/consts/lists.dart';
import 'package:get/get.dart';
import 'package:projects/views/auth_screen/signup_screen.dart';
import 'package:projects/views/home_screen/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
   

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
                  .white
                  .size(22)
                  .make(),
              15.heightBox,
              Obx(
                () => Column(
                children: [
                  customTextField(
                    hint: emailHint,
                    title: email,
                    isPass: false,
                    controller: controller.emailController,
                  ),
                  customTextField(
                    hint: passwordHint,
                    title: password,
                    isPass: true,
                    controller: controller.passwordController,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
  if (controller.emailController.text.isEmpty) {
    VxToast.show(context, msg: "Please enter your email first");
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: controller.emailController.text.trim(),
    );
    VxToast.show(context, msg: "Password reset link sent to your email");
  } catch (e) {
    VxToast.show(context, msg: "Error: ${e.toString()}");
  }
},
                      child: forgetPass.text.color(primaryColor).make(),
                    ),
                  ),
                  5.heightBox,
                  controller.isloading.value 
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation( softBlueGreen),
                  ) 
                  : ourButton(
                    color:  softBlueGreen,
                    title: login,
                    textColor: whiteColor,
                    onPress: () async {
                      controller.isloading(true);
                      try {
                        var userCred = await controller.loginMethod();
                        if (userCred != null) {
                          // Show success message first
                          Get.snackbar(
                            "Success",
                            "Login successful!",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          await Future.delayed(const Duration(seconds: 1));
                          // Then navigate
                          Get.offAll(() => const Home());
                        }else {
                          controller.isloading(false);
                        }
                      } catch (e) {
                        controller.isloading(false);
                        Get.snackbar(
                          "Login Failed",
                          e.toString(),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ).box.width(context.screenWidth - 50).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                    color: lightGolden,
                    title: signup,
                    textColor: redColor,
                    onPress: () {
                      Get.to(() => const SignupScreen());
                    },
                  ).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                  loginWith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      2,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: lightGrey,
                          radius: 25,
                          child: Image.asset(
                            socialIconList[index],
                            width: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
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
