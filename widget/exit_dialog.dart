import 'package:flutter/services.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/widget/our_button.dart';

Widget exitDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        Divider(),
        10.heightBox,
        "Are you sure you want to exit?"
        .text.size(16)
        .color(darkFontGrey)
        .make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
          children: [
            ourButton(
              color: softBlueGreen, 
              onPress: () {
                SystemNavigator.pop();
              }, 
              textColor: whiteColor,
              title: "Yes" ),
              ourButton(
              color: softBlueGreen, 
              onPress: () {
                Navigator.pop(context);
              }, 
              textColor: whiteColor,
              title: "No" ),
          ]
        )
      ],
    ).box
    .color(lightGrey)
    .padding(const EdgeInsets.all(12))
    .roundedSM
    .make(),

  );

}