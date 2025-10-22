import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/consts/lists.dart';
import 'package:projects/controllers/auth_controller.dart';
import 'package:projects/controllers/profile_controller.dart';
import 'package:projects/services/firestore_services.dart';
import 'package:projects/views/auth_screen/login_screen.dart';
import 'package:projects/views/chat_screen/messaging_screen.dart';
import 'package:projects/views/orders_screen/orders_screen.dart';
import 'package:projects/views/profile_screen/components/details_card.dart';
import 'package:projects/views/profile_screen/edit_profile_screen.dart';
import 'package:projects/views/wishlist_screen/wishlist_screen.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/loading_indicator.dart';




class ProfileScreen extends StatelessWidget{
  const ProfileScreen ({super.key});
  
  @override
  Widget build(BuildContext context){

    var controller = Get.put(ProfileController());
   

    return  bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid), 
          
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if(!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(softBlueGreen),
              ) 
            );
            }
            else {

              var data = snapshot.data!.docs[0];

              return SafeArea(
          child: Column(
            children: [

              //edit profile button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Align(alignment: Alignment.topRight, child: Icon(Icons.edit, color: whiteColor)).onTap((){
                  controller.nameController.text = data['name'];
                
                  
                  Get.to(() => EditProfileScreen(data: data));
                }),
              ),

             //users details section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0 ),
                child: Row(
                children: [
                  data['imgUrl'] == '' ? 
                  Image.asset(imgProfile, width: 90, fit: BoxFit.cover ).box.roundedFull.clip(Clip.antiAlias).make()
                  :
                  Image.network(data['imgUrl'], width: 90, fit: BoxFit.cover ).box.roundedFull.clip(Clip.antiAlias).make(),

                  10.widthBox,
                  Expanded(
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "${data['name']}".text.fontFamily(semibold).white.make(),
                      5.heightBox,
                      "${data['email']}".text.white.make(),
                    ],
                  )),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: whiteColor,
                       )),
                    
                    onPressed: () async{
                      //await Get.put(AuthController()).signoutMethod();
                     // Get.offAll(() => const LoginScreen());
                       final authController = Get.put(AuthController());
                       await authController.signoutMethod();
                       Get.offAll(() => const LoginScreen());
                    },
                   child: "Logout".text.fontFamily(semibold).white.make(), 
                   )
                ],
              ),
              ),
              
              20.heightBox,
              FutureBuilder(
                future: FirestoreServices.getCount(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(!snapshot.hasData){
                    return Center(child: loadingIndicator());
                  }else {
                    var countData = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      detailsCard(
                        count: countData[0].toString(), title: "in your cart", width: context.screenWidth / 3.7),
                      detailsCard(
                        count: countData[1].toString(), 
                        title: "in your wishlist",
                        width: context.screenWidth / 3.7),
                      detailsCard(
                        count: countData[2].toString(), title: "your orders", width: context.screenWidth / 3.7),
                ],
              );
              }
            },
           ),
              //to be
             /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  detailsCard(count: data['cart_count'], title: "in your cart", width: context.screenWidth / 3.7),
                  detailsCard(count: data['wishlist_count'], title: "in your wishlist", width: context.screenWidth / 3.7),
                  detailsCard(count: data['order_count'], title: "your orders", width: context.screenWidth / 3.7),
                ],
              ),*/

              //buttons section
              40.heightBox,
             ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: lightGrey,

                );
              },
              itemCount: profileButtonsList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    switch (index){
                      case 0:
                      Get.to(() => OrdersScreen());
                      break;
                      case 1: Get.to(()=>WishlistScreen());
                      break;
                      case 2: Get.to(()=>MessagesScreen());
                      break;
                    }
                  },
                  leading: Image.asset(
                    profileButtonsIcon[index],
                  width: 22,
                  ),
                  title: profileButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                );
              },
             ).box
             .white
             .rounded
             .margin(EdgeInsets.all(12))
             .padding(const EdgeInsets.symmetric(horizontal: 16))
             .shadowSm
             .make()
             .box
             .color(softBlueGreen)
             .make(),
            ],
          ));
              
            } 


           
          }
          )
        ),
    

    );
  }  
}