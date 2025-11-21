import 'package:projects/seller/consts/const.dart';

Widget sLoadingIndicator({circleColor = purpleColor}) {
  return  Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}

/*Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(purpleColor),
  );

}*/