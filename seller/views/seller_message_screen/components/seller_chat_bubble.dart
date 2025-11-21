
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';


Widget sellerChatBubble({
  required String message,
  required bool isMe,
  required String time,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isMe ? purpleColor : green, // your colors
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isMe ? 20 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          normalText(
            text: message,
            color: isMe ? white : fontGrey,
          ),
          const SizedBox(height: 6),
          normalText(
            text: time,
            color: isMe ? red : fontGrey,
            size: 11,
          ),
        ],
      ),
    ),
  );
}


/*import 'package:seller_side/consts/const.dart';
import 'package:seller_side/views/widgets/text_style.dart';


Widget chatBubble() {

  return Directionality(
   //: data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
   textDirection : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        
     // color: data['uid'] == currentUser!.uid ? red: darkGrey,
      color: purpleColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       // "${data['msg']}".text.white.size(16).make(),
        normalText(text: "Your message here..."),
          10.heightBox,
         // time.text.color(fontGrey).make(),
          normalText(text: "10:45PM"),
        ],

      ),

    ),
  );
}*/


/*import 'package:seller_side/consts/const.dart';
import 'package:seller_side/views/widgets/text_style.dart';


Widget chatBubble() {

  return Directionality(
   //: data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
   textDirection : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        
     // color: data['uid'] == currentUser!.uid ? red: darkGrey,
      color: purpleColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       // "${data['msg']}".text.white.size(16).make(),
        normalText(text: "Your message here..."),
          10.heightBox,
         // time.text.color(fontGrey).make(),
          normalText(text: "10:45PM"),
        ],

      ),

    ),
  );
}*/