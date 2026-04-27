/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_auth_screen/seller_signup_screen.dart';
import 'package:projects/seller/views/seller_home_screen/seller_home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}
 class _MyAppState extends State<MyApp>{
  @override
  void initState(){
    super.initState();
    checkUser();
  }

  var isLoggedin = false;

  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        isLoggedin = false;
      }else {
        isLoggedin = true;
      }
      setState(() {});

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,    
      home: isLoggedin ? const SellerHome() : const SellerSignupScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation:0.0
        ),
      ),
    );
  }
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_auth_screen/seller_login_screen.dart';
import 'package:projects/seller/views/seller_auth_screen/seller_signup_screen.dart';
import 'package:projects/seller/views/seller_home_screen/seller_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,

      // 🔥 IMPORTANT: Auth gate (NO more isLoggedin bool)
      home: const AuthWrapper(),

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // logged in → Seller Home
        if (snapshot.hasData) {
          return const SellerHome();
        }

        // not logged in → Signup/Login screen
        return const SellerLoginScreen();
      },
    );
  }
}

 