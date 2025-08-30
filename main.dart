import 'package:projects/consts/consts.dart';
import 'package:projects/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    

    
  );
  
      
  
}

}