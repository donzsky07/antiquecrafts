
import 'package:get/get.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';
import 'package:projects/views/auth_screen/signup_screen.dart';
import 'package:projects/consts/consts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the refactored AuthController
    var controller = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: context.screenHeight * 0.1),
              applogoWidget(),
              const SizedBox(height: 10),
              Text(
                "Log in to $appname",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              Obx(
                () => Column(
                  children: [
                    customTextField(
                      hint: "Enter your email",
                      title: "Email",
                      isPass: false,
                      controller: controller.emailController,
                    ),
                    customTextField(
                      hint: "Enter your password",
                      title: "Password",
                      isPass: true,
                      controller: controller.passwordController,
                    ),
                    const SizedBox(height: 10),

                    // Login button / loading
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Colors.blueAccent),
                          )
                        : ourButton(
                            color: Colors.blueAccent,
                            title: "Login",
                            textColor: Colors.white,
                            onPress: () {
                              controller.login();
                            },
                          ).box.width(context.screenWidth - 50).make(),

                    const SizedBox(height: 10),
                    const Text("Create a new account",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 5),
                    ourButton(
                      color:  Colors.blueAccent,
                      title: "Signup",
                      textColor: Colors.white,
                      onPress: () {
                        Get.to(() => const SignupScreen());
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
