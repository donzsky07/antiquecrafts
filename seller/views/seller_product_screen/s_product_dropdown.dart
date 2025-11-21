import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/products_controller.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';


Widget sProductDropdown(hint, List<String> list, dropvalue, SellerProductsController controller){
  return Obx(
    () => DropdownButtonHideUnderline(
    child: DropdownButton(
      hint: normalText(text: "$hint", color: fontGrey),
      value: dropvalue == '' ? null: dropvalue.value,
      isExpanded: true,
      items: list.map((e) {
        return DropdownMenuItem(
          value: e,
          child: e.toString().text.make(), 
          
        );
      }).toList(),
      onChanged: (newValue) {
        if(hint == "Category"){
          controller.subcategoryvalue.value = '';
          controller.populateSubcategory(newValue.toString());
          }
          dropvalue.value = newValue.toString();
      },
      ),
    ).box.white.padding(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.make()
  );
}