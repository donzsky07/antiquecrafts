import 'dart:io';

import 'package:get/get.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/seller_profile_controller.dart';
import 'package:projects/seller/views/seller_widgets/s_custom_textfield.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';


class SEditProfileScreen extends StatefulWidget {
  final String? username;
  const SEditProfileScreen({super.key, this.username});

  @override
  State<SEditProfileScreen> createState() => _EditProfileScreenState();

}

class _EditProfileScreenState extends State<SEditProfileScreen> {
   var controller = Get.find<SellerProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return Obx(
      () => Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      appBar: AppBar(
         leading: IconButton(onPressed: (){
          Get.back();
        },
        icon: Icon(Icons.arrow_back, color: white),
      ),
      title: boldText(text: editProfile, size: 18.0),
      actions: [
        controller.isloading.value
        ? sLoadingIndicator(circleColor: white)
        : TextButton(onPressed: () async{
          controller.isloading(true);
            //if image is not selected
          if(controller.profileImgPath.value.isNotEmpty) {
            await controller.uploadProfileImage();

          }else {
            controller.profileImageLink = controller.snapshotData['imgUrl'];
          }

          //if old password matches database
          if(controller.snapshotData['password'] == controller.oldpassController.text) {
            await controller.changeAuthPassword(
              email: controller.snapshotData['email'],
              password: controller.oldpassController.text,
              newpassword: controller.newpassController.text);

              await controller.updateProfile(
                imgUrl: controller.profileImageLink,
                name: controller.nameController.text,
                password: controller.newpassController.text );

                VxToast.show(context, msg: "Updated successfully");
          }else if(controller.oldpassController.text.isEmptyOrNull && 
                controller.newpassController.text.isEmptyOrNull) {
                await controller.updateProfile(
                imgUrl: controller.profileImageLink,
                name: controller.nameController.text,
                password: controller.snapshotData['password'] );

            }else {
               VxToast.show(context, msg: "Some error occured");
               controller.isloading(false);
            }
       },
        child: normalText(text: save, color: white, size: 18.0))
      ],
     ),
     body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column (
        children: [
              //if data image url and controller path is empty
              controller.snapshotData['imgUrl'] == '' && controller.profileImgPath.isEmpty
              ? Image.asset(imgproduct, width: 100, fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()

              //if data is not empty but controller path is empty
              : controller.snapshotData['imgUrl'] != '' && controller.profileImgPath.isEmpty
              ? Image.network (
                controller.snapshotData['imgUrl'],
                width: 100,
                fit: BoxFit.cover,
                
              ).box.roundedFull.clip(Clip.antiAlias).make()

                //else if controller path is not empty 
              : Image.file(
                File(controller.profileImgPath.value),
                width: 100,
                fit: BoxFit.cover,
              ).box.roundedFull.clip(Clip.antiAlias).make(),

          //Image.asset(imgproduct,width: 150,).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: white),
              onPressed: (){
                controller.changeImage(context);
              }, child: normalText(text: changeImage, color: fontGrey),
            ),
            10.heightBox,
            const Divider(color: white),
            sCustomTextField(label: name, hint: "eg. Santurdio Devs", controller: controller.nameController),
            30.heightBox,
            Align(alignment: Alignment.centerLeft, child: boldText(text: "Change your password")),
            10.heightBox,
            sCustomTextField(label: password, hint: passwordHint, controller: controller.oldpassController), 
            10.heightBox,
            sCustomTextField(label: confirmPass, hint: passwordHint, controller: controller.newpassController),  

        ],
      ),
      ), 
    ),
  );

  
  }

}