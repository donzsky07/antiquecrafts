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

    return bgWidget(
      child: Scaffold (
        appBar: AppBar(),
         
          body: Obx(
            () => Column (
            mainAxisSize: MainAxisSize.min,
            children: [

                data['imageUrl'] == '' && controller.profileImgPath.isEmpty 
                ? Image.asset(imgProfile, width: 100, fit: BoxFit.cover ).box.roundedFull.clip(Clip.antiAlias).make() 
                : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                ? Image.network(data['imageUrl']) // for image network 
      
                : Image.file(
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
                  customTextField(
                    controller: controller.passController,
                    hint: passwordHint, 
                    title: password, 
                    isPass: true
                    ),
                20.heightBox,
                controller.isloading.value ? CircularProgressIndicator(
                  valueColor :AlwaysStoppedAnimation(redColor),

                ): SizedBox(
                  width: context.screenWidth - 60,
                  child: ourButton(
                    color: redColor, 
                  onPress: () async {
                    controller.isloading(true);

                    await controller.uploadProfileImage();
                    await controller.updateProfile(
                       controller.profileImageLink,
                       controller.nameController.text,
                       controller.passController.text);
                    VxToast.show(context, msg: "Updated");
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