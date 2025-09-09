import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/product_controller.dart';
import 'package:projects/widget/bg_widget.dart';
import 'package:get/get.dart';
import  'package:projects/views/category_screen/item_details.dart';

class CategoryDetails extends StatelessWidget{
  final String? title;
  const CategoryDetails({super.key, required this.title} );

   @override
  Widget build(BuildContext context){

    var controller = Get.find<ProductController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: title!.text.fontFamily(bold).white.make() 
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal, 
              
             child: Row(
                children: List.generate(
                  controller.subcat.length,
                  (index) =>"${controller.subcat[index]}"
                  .text
                  .size(12)
                  .fontFamily(semibold)
                  .color(darkFontGrey)
                  .makeCentered()
                  .box
                  .white
                  .rounded
                  .size(120, 60)
                  .margin(EdgeInsets.symmetric(horizontal: 4))
                  .make()),
              ),
              ),

              //items container
              20.heightBox,
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 250, mainAxisSpacing: 8, crossAxisSpacing: 8),
                  itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        imgP5, 
                        height:150,
                        width: 200,
                         fit: BoxFit.cover, 
                    ),
                    10.heightBox,
                    "Laptop 4GB/64GB".text.fontFamily(semibold).color(darkFontGrey).make(),
                    10.heightBox,
                    "₱30000".text.color(redColor).fontFamily(bold).size(16).make()
                    
                    ],
                  ).box
                  .white
                  .margin(EdgeInsets.symmetric(horizontal: 4))
                  .roundedSM
                  .outerShadowSm
                  .padding(EdgeInsets.all(12))
                  .make()
                  .onTap(() {
                    Get.to(() => const ItemDetails(title:"Dummy Item" ));
                  }); 
              }),

              ),

            ],
          ),
        ),
        ),
    );

  }


}