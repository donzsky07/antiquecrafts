import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';


Widget sOurButton({title, color = purpleColor,onPress}){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
      backgroundColor: purpleColor,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress, 
    child: normalText(
      text: title, 
      size: 16.0,
      ),
    );
}