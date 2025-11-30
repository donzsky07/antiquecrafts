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

                                // 2️⃣ CHECK VENDORS COLLECTION FIRST
                                final vendorDoc =
                                    await FirebaseFirestore.instance
                                        .collection("vendors")
                                        .doc(uid)
                                        .get();

                                if (vendorDoc.exists) {
                                  controller.isloading(false);

                                  Get.snackbar(
                                    "Success",
                                    "Welcome Seller!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Get.offAll(
                                      () => const SellerHome());
                                  return;
                                }

                                // 3️⃣ CHECK USERS COLLECTION NEXT
                                final userDoc =
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .get();

                                if (userDoc.exists) {
                                  controller.isloading(false);

                                  Get.snackbar(
                                    "Success",
                                    "Login successful!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Get.offAll(() => const Home());
                                  return;
                                }

                                // 4️⃣ NO MATCH FOUND IN BOTH COLLECTIONS
                                controller.isloading(false);
                                Get.snackbar(
                                  "Error",
                                  "Account does not exist in Firestore.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
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
