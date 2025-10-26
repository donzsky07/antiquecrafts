import 'package:projects/consts/consts.dart';
import 'package:get/get.dart';
import 'package:projects/controllers/home_controller.dart';
import 'package:projects/views/home_screen/home_screen.dart';
import 'package:projects/views/category_screen/category_screen.dart';
import 'package:projects/views/cart_screen/cart_screen.dart';
import 'package:projects/views/profile_screen/profile_screen.dart';
import 'package:projects/widget/exit_dialog.dart';



class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context ){

    var controller = Get.put(HomeController()); 

    var navbarItem = [ 
      BottomNavigationBarItem(icon: Image.asset(icHome, width: 26), label: home ),
      BottomNavigationBarItem(icon: Image.asset(icCategories, width: 26), label: categories ),
      BottomNavigationBarItem(icon: Image.asset(icCart, width: 26), label: cart ),
      BottomNavigationBarItem(icon: Image.asset(icProfile, width: 26), label: account ),
    ];

    var navBody = [
     const HomeScreen(),
     const CategoryScreen(),
     const CartScreen(),
     const ProfileScreen(),
    ];
    //edited/fixed
     /*return Obx(() {
      // show a small loading screen while fetching user data
      if (controller.userData.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }*/

    return PopScope(
      canPop: false,
      onPopInvokedWithResult:(didPop, result) async {
        if (!didPop) {
          final shouldExit = await  showDialog<bool>(
            context: context, 
            builder: (context) => exitDialog(context),
            );
          if (shouldExit == true) {
            Navigator.of(context).pop();
          }
        }
        
      },
    child: Scaffold(
      body: Column(
        children: [
          Obx (() => Expanded (child: navBody.elementAt(controller.currentNavIndex.value))),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          selectedItemColor: redColor,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navbarItem,
          onTap: (value){
            controller.currentNavIndex.value = value ;
          },
        )
      ),
    ));
   
  }

}