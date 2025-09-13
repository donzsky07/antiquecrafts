import 'package:projects/consts/consts.dart';


Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(softBlueGreen),
  );

}