<<<<<<< HEAD

import 'package:get/get.dart';
=======
/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/consts/consts.dart';
>>>>>>> f5bf3bc (v3 in 1)
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
}*/


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/seller/views/seller_home_screen/seller_home.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';
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
                    10.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(softBlueGreen),
                          )
                        : ourButton(
                            color: softBlueGreen,
                            title: login,
                            textColor: whiteColor,
                            onPress: () async {
                              controller.isloading(true);

                              try {
                                // 1️⃣ LOGIN VIA FIREBASE AUTH
                                var userCred =
                                    await controller.loginMethod();

                                if (userCred == null) {
                                  controller.isloading(false);
                                  return;
                                }

                                final uid = FirebaseAuth
                                    .instance.currentUser!.uid;

                                // 2️⃣ GET USER DOCUMENT FROM SINGLE COLLECTION
                                final userDoc = await FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .doc(uid)
                                    .get();

                                if (!userDoc.exists) {
                                  controller.isloading(false);
                                  Get.snackbar(
                                    "Error",
                                    "Account does not exist in Firestore.",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                // 3️⃣ CHECK ROLE
                                final role = userDoc['role'];

                                controller.isloading(false);

                                if (role == 'seller') {
                                  Get.snackbar(
                                    "Success",
                                    "Welcome Seller!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  Get.offAll(() => const SellerHome());
                                } else if (role == 'user') {
                                  Get.snackbar(
                                    "Success",
                                    "Login successful!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  Get.offAll(() => const Home());
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Role not recognized.",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
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
                    10.heightBox,
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
