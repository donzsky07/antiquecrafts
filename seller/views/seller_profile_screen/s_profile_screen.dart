/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_profile_controller.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/dashboard/seller_rating_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/seller_blocked_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/seller_feedback_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/seller_report_screen.dart';
import 'package:projects/seller/views/seller_shop_screen/s_shop_settings.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:projects/seller/views/seller_message_screen/seller_messages_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/s_edit_profilescreen.dart';
import 'package:projects/consts/colors.dart';
import 'package:projects/views/auth_screen/login_screen.dart';



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
          await Get.find<AuthController>().signout();
          Get.offAll(() => const LoginScreen());
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

  case 2:
    Get.to(() => const SellerRatingsScreen());
    break;

    case 3:
    Get.to(() => const SellerFeedbackScreen());
    break;

  case 4:
    Get.to(() => const ReportedUsersScreen());
    break;

  case 5:
    Get.to(() => const UsersManagementScreen ());
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
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_profile_controller.dart';
import 'package:projects/seller/services/store_services.dart';

import 'package:projects/seller/views/dashboard/seller_rating_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/seller_blocked_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/seller_feedback_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/seller_report_screen.dart';

import 'package:projects/seller/views/seller_shop_screen/s_shop_settings.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

import 'package:projects/seller/views/seller_message_screen/seller_messages_screen.dart';
import 'package:projects/seller/views/seller_profile_screen/s_edit_profilescreen.dart';

import 'package:projects/consts/colors.dart';
import 'package:projects/views/auth_screen/login_screen.dart';

class SProfileScreen extends StatelessWidget {
  const SProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(
      SellerProfileController(),
    );

    return Scaffold(
      backgroundColor: purpleColor,

      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: purpleColor,
        elevation: 0,

        title: boldText(
          text: settings,
          size: 18.0,
        ),

        actions: [

          /// EDIT BUTTON
          IconButton(
            onPressed: () {

              // 🔥 SAFE CHECK
              if (controller.snapshotData == null) {
                Get.snackbar(
                  "Error",
                  "Seller profile not loaded",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              Get.to(
                () => SEditProfileScreen(
                  username:
                      controller.snapshotData[
                          'vendor_name'],
                ),
              );
            },

            icon: const Icon(
              Icons.edit,
              color: white,
            ),
          ),

          /// LOGOUT BUTTON
          TextButton(
            onPressed: () async {

              try {

                await FirebaseAuth.instance
                    .signOut();

                Get.offAll(
                  () => const LoginScreen(),
                );

              } catch (e) {

                Get.snackbar(
                  "Logout Failed",
                  e.toString(),

                  backgroundColor: Colors.red,
                  colorText: Colors.white,

                  snackPosition:
                      SnackPosition.BOTTOM,
                );
              }
            },

            child: normalText(
              text: logout,
              size: 18.0,
            ),
          ),
        ],
      ),

      body: FutureBuilder(
        future: StoreServices.getProfile(
          currentUser!.uid,
        ),

        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {

          /// LOADING
          if (!snapshot.hasData) {

            return sLoadingIndicator(
              circleColor: white,
            );
          }

          /// 🔥 EMPTY CHECK FIX
          if (snapshot.data!.docs.isEmpty) {

            return const Center(
              child: Text(
                "No seller profile found",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          /// DATA EXISTS
          controller.snapshotData =
              snapshot.data!.docs[0];

          return Column(
            children: [

              /// PROFILE INFO
              ListTile(

                leading:
                    controller.snapshotData[
                                'imgUrl'] ==
                            ''

                        ? Image.asset(
                            imgproduct,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                            .box
                            .roundedFull
                            .clip(
                              Clip.antiAlias,
                            )
                            .make()

                        : Image.network(
                            controller.snapshotData[
                                'imgUrl'],
                            width: 100,
                            fit: BoxFit.cover,
                          )
                            .box
                            .roundedFull
                            .clip(
                              Clip.antiAlias,
                            )
                            .make(),

                title: boldText(
                  text:
                      "${controller.snapshotData['vendor_name']}",
                ),

                subtitle: normalText(
                  text:
                      "${controller.snapshotData['email']}",
                ),
              ),

              const Divider(),

              10.heightBox,

              /// MENU LIST
              Padding(
                padding:
                    const EdgeInsets.all(8.0),

                child: Column(

                  children: List.generate(
                    profileButtonsIcons.length,

                    (index) => ListTile(

                      onTap: () {

                        switch (index) {

                          case 0:

                            Get.to(
                              () =>
                                  const SShopSettings(),
                            );

                            break;

                          case 1:

                            Get.to(
                              () =>
                                  const SMessagesScreen(),
                            );

                            break;

                          case 2:

                            Get.to(
                              () =>
                                  const SellerRatingsScreen(),
                            );

                            break;

                          case 3:

                            Get.to(
                              () =>
                                  const SellerFeedbackScreen(),
                            );

                            break;

                          case 4:

                            Get.to(
                              () =>
                                  const ReportedUsersScreen(),
                            );

                            break;

                          case 5:

                            Get.to(
                              () =>
                                  const UsersManagementScreen(),
                            );

                            break;

                          default:
                        }
                      },

                      leading: Icon(
                        profileButtonsIcons[index],
                        color: white,
                      ),

                      title: normalText(
                        text:
                            profileButtonsTitles[
                                index],
                        size: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}