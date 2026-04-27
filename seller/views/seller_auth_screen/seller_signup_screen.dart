
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/seller/controllers/seller_auth_controller.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class SellerSignupScreen extends StatefulWidget {
  const SellerSignupScreen({super.key});

  @override
  State<SellerSignupScreen> createState() => _SellerSignupScreenState();
}

class _SellerSignupScreenState extends State<SellerSignupScreen> {
  bool isCheck = false;

  var controller = Get.put(SellerAuthController());

  // Controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();
  var storeNameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: context.screenHeight * 0.1),
                applogoWidget(),
                const SizedBox(height: 10),

                "Become a Seller"
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
                        hint: nameHint,
                        title: name,
                        controller: nameController,
                        isPass: false,
                      ),
                      customTextField(
                        hint: emailHint,
                        title: email,
                        controller: emailController,
                        isPass: false,
                      ),
                      customTextField(
                        hint: passwordHint,
                        title: password,
                        controller: passwordController,
                        isPass: true,
                      ),
                      customTextField(
                        hint: passwordHint,
                        title: retypePassword,
                        controller: retypePasswordController,
                        isPass: true,
                      ),

                      // 🔥 Seller fields
                      customTextField(
                        hint: "Store Name",
                        title: "Store Name",
                        controller: storeNameController,
                        isPass: false,
                      ),
                      customTextField(
                        hint: "Phone",
                        title: "Phone",
                        controller: phoneController,
                        isPass: false,
                      ),

                      const SizedBox(height: 10),

                      // Terms
                      Row(
                        children: [
                          Checkbox(
                            activeColor: softBlueGreen,
                            checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (val) {
                              setState(() {
                                isCheck = val ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "I agree to Terms & Privacy Policy",
                              style: TextStyle(color: fontGrey),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Button
                      controller.isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(softBlueGreen),
                            )
                          : ourButton(
                              color: isCheck ? softBlueGreen : lightGrey,
                              title: "Sign Up as Seller",
                              textColor: whiteColor,
                              onPress: () async {
                                final messenger =
                                    ScaffoldMessenger.of(context);

                                if (!isCheck) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content: Text("Agree to terms")),
                                  );
                                  return;
                                }

                                if (passwordController.text.trim() !=
                                    retypePasswordController.text.trim()) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Passwords do not match")),
                                  );
                                  return;
                                }

                                controller.isLoading.value = true;

                                try {
                                  await controller.signupSeller(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password:
                                        passwordController.text.trim(),
                                    storeName:
                                        storeNameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                  );

                                  Get.snackbar(
                                    "Success",
                                    "Seller account created!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  Get.back(); // balik login
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    e.toString(),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } finally {
                                  controller.isLoading.value = false;
                                }
                              },
                            ).box.width(context.screenWidth - 50).make(),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Already have account?"
                              .text
                              .color(fontGrey)
                              .make(),
                          const SizedBox(width: 5),
                          "Login"
                              .text
                              .color(softBlueGreen)
                              .make()
                              .onTap(() {
                            Get.back();
                          }),
                        ],
                      ),
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
      ),
    );
  }
}