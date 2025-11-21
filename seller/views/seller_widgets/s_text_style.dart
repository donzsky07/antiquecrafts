import 'package:projects/seller/consts/const.dart';

Widget normalText({text, color = Colors.white, double size = 14.0}) {
  return "$text".text.color(color).size(size.toDouble()).make();
}

Widget boldText({text, color = Colors.white, double size = 14.0}) {
  return "$text".text.semiBold.color(color).size(size.toDouble()).make();
}