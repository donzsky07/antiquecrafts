//import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects/consts/consts.dart';
//import 'package:projects/controllers/auth_controller.dart';
//import 'package:projects/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'package:projects/views/auth_screen/login_screen.dart';
//import 'package:projects/views/home_screen/home.dart';
import 'package:projects/views/splash_screen/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Register controllers once here
 // Get.put(AuthController(), permanent: true);
  
  //  Add this block to activate App Check debug mode
 /* await FirebaseAppCheck.instance.activate(
   androidProvider: AndroidProvider.debug,

  );*/
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});


@override
Widget build(BuildContext context){

  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: appname,
    theme: ThemeData( 
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        //to set appbar icons color
        iconTheme: IconThemeData(
          color: darkFontGrey,
        ),
        elevation: 0.0,
        backgroundColor:Colors.transparent),
      fontFamily: regular,
    ),
   home: const SplashScreen(),
   /* home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // While Firebase is checking the auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If user is logged in, go to home
          if (snapshot.hasData) {
            return const Home();
          }

          // If user is logged out, go to login screen
          return const LoginScreen();
        },
      ),*/
    );
      
}

}