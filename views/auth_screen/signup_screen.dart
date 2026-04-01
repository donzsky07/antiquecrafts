/*import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/views/home_screen/home.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;

  var controller = Get.put(AuthController());

  // Text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  var uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Join the $appname".text.fontFamily(bold).white.size(22).make(),
                15.heightBox,
                Obx(
                  () => Column(
                    children: [
                      customTextField(
                          hint: nameHint,
                          title: name,
                          controller: nameController,
                          isPass: false),
                      customTextField(
                          hint: emailHint,
                          title: email,
                          controller: emailController,
                          isPass: false),
                      customTextField(
                          hint: passwordHint,
                          title: password,
                          controller: passwordController,
                          isPass: true),
                      customTextField(
                          hint: passwordHint,
                          title: retypePassword,
                          controller: passwordRetypeController,
                          isPass: true),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: forgetPass.text.color(primaryColor).make(),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: redColor,
                            checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue ?? false;
                              });
                            },
                          ),
                          10.widthBox,
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(
                                        fontFamily: regular, color: fontGrey),
                                  ),
                                  TextSpan(
                                    text: termAndCon,
                                    style: TextStyle(
                                        fontFamily: regular, color: redColor),
                                  ),
                                  TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                        fontFamily: regular, color: fontGrey),
                                  ),
                                  TextSpan(
                                    text: privacyPolicy,
                                    style: TextStyle(
                                        fontFamily: regular, color: redColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      5.heightBox,
                      controller.isloading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation( softBlueGreen),
                            )
                          : ourButton(
                              color: isCheck ? softBlueGreen: lightGrey,
                              title: signup,
                              textColor: whiteColor,
                              onPress: () async {
                                controller.isloading(true);
                                if (isCheck != true) return;

                                // Capture messenger before async gaps
                                final messenger = ScaffoldMessenger.of(context);

                                try {
                                  var userCredential =
                                      await controller.signupMethod(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  if (userCredential != null) {
                                    await controller.storeUserData(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                    );

                                    messenger.showSnackBar(
                                      const SnackBar(
                                          content: Text("Sign up successfully")),
                                    );
                                    Get.offAll(() => const Home());
                                  } else {
                                    messenger.showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Signup failed. Please try again.")),
                                    );
                                  }
                                } catch (e) {
                                  auth.signOut();
                                  messenger.showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                  controller.isloading(false);
                                }
                              },
                            ).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          alreadyHaveAccount.text.color(fontGrey).size(16).make(),
                          login.text.color(redColor).size(18).make().onTap(() {
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
}*/




import 'package:get/get.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;

  // Controller instance
  var controller = Get.put(AuthController());

  // Text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

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
                Text(
                  "Join the $appname",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
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
                        controller: passwordRetypeController,
                        isPass: true,
                      ),

                      // Terms checkbox
                      Row(
                        children: [
                          Checkbox(
                            activeColor: redColor,
                            checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(
                                        fontFamily: regular,
                                        color: fontGrey),
                                  ),
                                  TextSpan(
                                    text: termAndCon,
                                    style: TextStyle(
                                        fontFamily: regular,
                                        color: redColor),
                                  ),
                                  TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                        fontFamily: regular,
                                        color: fontGrey),
                                  ),
                                  TextSpan(
                                    text: privacyPolicy,
                                    style: TextStyle(
                                        fontFamily: regular,
                                        color: redColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Signup button or loading indicator
                      controller.isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(softBlueGreen),
                            )
                          : ourButton(
                              color: isCheck ? softBlueGreen : lightGrey,
                              title: signup,
                              textColor: whiteColor,
                              onPress: () async {
                                final messenger =
                                    ScaffoldMessenger.of(context);

                                // ✅ Check if terms agreed
                                if (!isCheck) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "You must agree to the terms.")),
                                  );
                                  return;
                                }

                                // ✅ Check if passwords match
                                if (passwordController.text.trim() !=
                                    passwordRetypeController.text.trim()) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Passwords do not match!")),
                                  );
                                  return;
                                }

                                // ✅ Start loading
                                controller.isLoading.value = true;

                                try {
                                  // 1️⃣ Signup with Firebase Auth
                                  await controller.signup(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  // 2️⃣ Navigate to User Home
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Signup successful!")),

                                  );
                                } catch (e) {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                } finally {
                                  controller.isLoading.value = false;
                                }
                              },
                            ).box.width(context.screenWidth - 50).make(),

                      const SizedBox(height: 10),

                      // Already have account?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            alreadyHaveAccount,
                            style: const TextStyle(color: fontGrey, fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            login,
                            style: const TextStyle(color: redColor, fontSize: 18),
                          ).onTap(() {
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
