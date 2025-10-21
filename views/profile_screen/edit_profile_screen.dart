import 'dart:io';

import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/profile_controller.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:projects/widget/custom_textfield.dart';
import 'package:projects/widget/our_button.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget{
  final dynamic data;

  const EditProfileScreen ({super.key, this.data});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<ProfileController>();
    controller.nameController.text = data['name'];
    controller.newpassController.text = data['password'];
    
    return bgWidget(
      child: Scaffold (
         resizeToAvoidBottomInset: false,
        appBar: AppBar(),
         
          body: Obx(
            () => Column (
            mainAxisSize: MainAxisSize.min,
            children: [
                //data['imageUrl'] == '' &&-------
                data['imgUrl'] == '' && controller.profileImgPath.isEmpty 
                ? Image.asset(imgProfile, width: 100, fit: BoxFit.cover ).box.roundedFull.clip(Clip.antiAlias).make()
                : data['imgUrl'] != '' && controller.profileImgPath.isEmpty
                ? Image.network(data['imgUrl']) // for image network */
      
                :  Image.file(
                    File(controller.profileImgPath.value),
                     width: 100,
                    fit: BoxFit.cover,
                   ).box.roundedFull.clip(Clip.antiAlias).make(),

                10.heightBox,
                ourButton(
                  color: redColor, 
                  onPress: (){
                    controller.changeImage(context);
                  },
                  textColor: whiteColor, title: "Change"),
              const Divider(),
                20.heightBox,
                  customTextField(
                    controller: controller.nameController,
                    hint: nameHint, 
                    title: name, 
                    isPass: false
                    ),
                  10.heightBox,
                  customTextField(
                    controller: controller.oldpassController,
                    hint: passwordHint, 
                    title: oldpass, 
                    isPass: true
                    ),
                  10.heightBox,
                  customTextField(
                    controller: controller.newpassController,
                    hint: passwordHint, 
                    title: newpass, 
                    isPass: true
                    ),
                20.heightBox,
                controller.isloading.value ? CircularProgressIndicator(
                  valueColor :AlwaysStoppedAnimation(softBlueGreen),

                ): SizedBox(
                  width: context.screenWidth - 60,
                  child: ourButton(
                    color: redColor, 
                  onPress: () async {

                    controller.isloading(true);

                    //if is not selected ----
                   if(controller.profileImgPath.value.isNotEmpty){
                      await controller.uploadProfileImage();
                      }else {
                        controller.profileImageLink = data['imgUrl'];
                      } 

                      //if old password matches database---
                      if (data['password'] == controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                          email: data['email'],
                          password: controller.oldpassController.text,
                          newpassword: controller.newpassController.text);
                     //await controller.uploadProfileImage();---
                       await controller.uploadProfileImage();
                       await controller.updateProfile(
                        imgUrl: controller.profileImageLink,
                        name:controller.nameController.text,
                        password:controller.newpassController.text);
                    VxToast.show(context, msg: "Updated"); 
                  }else {
                    VxToast.show(context, msg:"Wrong old password ");
                    controller.isloading(false);
                  }
              
                  }, 
                  textColor: whiteColor, title: "Save" ),
                ),
                ],

          ),
          )
          .box
          .white
          .shadowSm
          .padding(const EdgeInsets.all(16))
          .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
          .rounded
          .make(),
          ),
      
    );
   
   
  }
  
}