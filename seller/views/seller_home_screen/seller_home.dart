import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/home_controller.dart';
import 'package:projects/seller/views/seller_home_screen/seller_home_screen.dart';
import 'package:projects/seller/views/seller_order_screen/seller_order_screen.dart';
import 'package:projects/seller/views/seller_product_screen/s_product_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/s_profile_screen.dart';


class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SellerHomeController());

    var navScreens = [
      SellerHomeScreen(), SProductsScreen(),SellerOrdersScreen(), SProfileScreen()];

    var bottomNavbar = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: dashboard),
     BottomNavigationBarItem(icon: Image.asset(icProduct, color: darkGrey, width: 24), label: product),
     BottomNavigationBarItem(icon: Image.asset(icOrders, width: 24, color: darkGrey), label: orders ),
     BottomNavigationBarItem(icon: Image.asset(icGeneralSettings, width: 24, color: darkGrey), label: settings),
  ];
    return Scaffold(
      bottomNavigationBar: Obx(
        () =>  BottomNavigationBar(
        onTap: (index) {
          controller.navIndex.value = index;
        },
        currentIndex: controller.navIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: purpleColor,
        unselectedItemColor: darkGrey,
        items: bottomNavbar),
      ),
      body: Obx(
        () =>Column(
        children: [
          Expanded(
            child: navScreens.elementAt(controller.navIndex.value)),
        ]
      ), ),
    );
  }

}