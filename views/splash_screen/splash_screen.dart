
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/views/home_screen/home.dart';
import 'package:projects/widget/applogo_widget.dart';
import 'package:projects/views/auth_screen/login_screen.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});


@override
State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

 /* changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //Get.to(() => const LoginScreen());
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => const LoginScreen());
        }else{
          Get.to(() => const Home());

        }

      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }




  @override
  Widget build(BuildContext context ){
    return Scaffold(
      backgroundColor: softBlueGreen,
      body: Center(
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: Image.asset(icSplashBg, width: 300)),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,


          ],
        ),
      ),
    );
  
  }*/
   void changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;

      if (!mounted) return; // Prevent navigation after dispose

      if (user == null) {
        // No user logged in
        Get.offAll(() => const LoginScreen());
      } else {
        // User is already logged in
        Get.offAll(() => const Home());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlueGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(icSplashBg, width: 300),
            ),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,
          ],
        ),
      ),
    );
  }

}


