import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_auth_controller.dart';
import 'package:projects/seller/controllers/seller_profile_controller.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_auth_screen/seller_login_screen.dart';
import 'package:projects/seller/views/seller_shop_screen/s_shop_settings.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:projects/seller/views/seller_message_screen/seller_messages_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/s_edit_profilescreen.dart';



class SProfileScreen extends StatelessWidget {
  const SProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SellerProfileController());
    return Scaffold(
     
     backgroundColor: purpleColor,
     appBar: AppBar(
      automaticallyImplyLeading: true,
      title: boldText(text: settings, size: 18.0),
      actions: [
        IconButton(onPressed: () {
          Get.to(() =>  SEditProfileScreen(
            username: controller.snapshotData['vendor_name'],
          ));
        }, 
        icon: const Icon(Icons.edit, color: white)),
        TextButton(onPressed: () async{
          await Get.find<SellerAuthController>().signoutMethod();
          Get.offAll(() => const SellerLoginScreen());
        }, 
        child: normalText(text: logout, size: 18.0),)
      ],
     ),
     body: FutureBuilder(
      future: StoreServices.getProfile(currentUser!.uid),
      
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData){
          return sLoadingIndicator(circleColor:white);
        }else {
          controller.snapshotData = snapshot.data!.docs[0];
          
          return Column(
        children: [
          ListTile(
            leading: controller.snapshotData['imgUrl'] == ''

            ? Image.asset(imgproduct, width: 100, fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()
            
            : Image.network(controller.snapshotData['imgUrl'], width: 100).box.roundedFull.clip(Clip.antiAlias).make(),
     
            title: boldText(text: "${controller.snapshotData['vendor_name']}"),
            subtitle: normalText(text: "${controller.snapshotData['email']}" )
          ),
          const Divider(),
          10.heightBox,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: List.generate(profileButtonsIcons.length, 
              (index) => ListTile(
                onTap: (){
                  switch (index) {
                    case 0:
                    Get.to(() => const SShopSettings());

                    break;
                    case 1:
                    Get.to(() => const SMessagesScreen());

                    break;
                    default:

                  }
                },
                leading: Icon(profileButtonsIcons[index], color: white), 
                title: normalText(text: profileButtonsTitles[index],size: 18.0),
              )),
              ),
             ),

        ],
        );
        }
        
      },
      ),

    );


  }
}