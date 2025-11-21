import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_auth_screen/seller_login_screen.dart';
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
      home: isLoggedin ? const SellerHome() : const SellerLoginScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation:0.0
        ),
      ),
    );
  }
}


 