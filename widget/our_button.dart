import 'package:projects/consts/consts.dart';


Widget ourButton ({onPress, color, textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
     ),

    onPressed: onPress,
      child: title!.text.size(16).color(textColor).fontFamily(bold).make(),
   );
}