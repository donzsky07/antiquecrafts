import 'package:projects/seller/consts/const.dart';
import 'package:projects/consts/colors.dart';

Widget sLoadingIndicator({circleColor = purpleColor}) {
  return  Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}

