import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';
import 'package:intl/intl.dart' as intl;


AppBar sAppbarWidget(title) {
  return AppBar(
    backgroundColor: white,
        automaticallyImplyLeading: true,
        title: boldText(text: title, color: fontGrey, size: 18.0),
        actions: [
          Center(
            child:  normalText(text: intl.DateFormat('EEE, MMM d,' 'yyy').format(DateTime.now()), 
          color: purpleColor)),
         10.widthBox,
        ],
      );
  

}