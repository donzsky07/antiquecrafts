
import 'package:projects/consts/consts.dart';

Widget bgWidget({Widget? child }) {
  return Container(
    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(imgBackground1), fit: BoxFit.fill) ),
    child: child,
     );
  
}