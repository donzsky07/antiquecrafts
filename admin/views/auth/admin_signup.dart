import 'package:projects/admin/controllers/admin_authcontroller.dart';
import 'package:projects/consts/consts.dart';
import 'package:get/get.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class AdminSignupScreen extends StatelessWidget {
  const AdminSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAuthController());

    return bgWidget(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,

              "Admin Sign Up"
                  .text
                  .fontFamily(bold)
                  .white
                  .size(22)
                  .make(),

              15.heightBox,

              Obx(
                () =>Column(
  children: [
    customTextField(
      hint: emailHint,
      title: email,
      isPass: false,
      controller: controller.emailController,
    ),
    10.heightBox,
    customTextField(
      hint: passwordHint,
      title: password,
      isPass: true,
      controller: controller.passwordController,
    ),
    20.heightBox,

    controller.isLoading.value
        ? const CircularProgressIndicator()
        : ourButton(
            color: softBlueGreen,
            title: "Create Admin",
            textColor: whiteColor,
            onPress: () async {
              await controller.signupAdmin();
            },
          ).box.width(400).make(),

    15.heightBox,

    // 🔥 NEW LOGIN LINK
    GestureDetector(
      onTap: () {
        Get.back(); // or Get.to(() => AdminLoginScreen());
      },
      child: RichText(
        text: const TextSpan(
          text: "Have already an account? ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: "Login",
              style: TextStyle(
                color: softBlueGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
)
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