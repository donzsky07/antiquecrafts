import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/home_controller.dart';




class CartController extends GetxController {
  var totalP = 0.obs;
    


  // RxMap for selected items: itemId -> bool
  var selectedItems = <String, bool>{}.obs;

  // total price of selected items


  //text controller for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;

  var products = [];

  var vendors = [];

  var placingOrder = false.obs;

  
    
 
  calculate(data){
    totalP.value = 0;
    for (var i=0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
   }

    placeMyOrder({orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      "order_code":"233981237",
      "order_date": FieldValue.serverTimestamp(),
      "order_by": currentUser!.uid,
      "order_by_name": Get.find<HomeController>().username.value,
      "order_by_email": currentUser!.email,
      "order_by_address": addressController.text,
      "order_by_state": stateController.text,
      "order_by_city": cityController.text,
      "order_by_phone": phoneController.text,
      "order_by_postalcode": postalcodeController.text,
      "shipping_method": "Home Delivery",
      "payment_method": orderPaymentMethod,
      "order_placed": true,
      "order_confirmed": false,
      "order_delivered": false,
      "order_on_delivery": false,
      "total_amount": totalAmount,
      "orders": FieldValue.arrayUnion(products),
      "vendors" : FieldValue.arrayUnion(vendors),

    }); 
    placingOrder(false);

   }

   getProductDetails() {
   products.clear();
   vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        "vendor_id": productSnapshot[i]['vendor_id'],
        "tprice": productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title']

      });

      vendors.add(productSnapshot[i]['vendor_id']);
     }
    }



   //PlaceMyOrder

/*Future<void> placeMyOrder({
  required String orderPaymentMethod,
  required double totalAmount,
}) async {
  placingOrder.value = true;

  try {

    // 🔥 Generate random order code
    String orderCode = generateOrderCode();
   
    // 🔥 Firestore order document
    await FirebaseFirestore.instance.collection('orders').add({
      'order_code': orderCode,
      'order_date': Timestamp.now(),
      'total_amount': totalAmount.toInt(), // convert double to int if needed
      'payment_method': orderPaymentMethod,
      'order_by_name': currentUser!.displayName ?? '',
      'order_by_email': currentUser!.email ?? '',
      'order_by_address': 'Sample Address', // replace with real data
      'order_by_city': 'Sample City',
      'order_by_state': 'Sample State',
      'order_by_phone': '09123456789',
      'order_by_postalcode': '1234',
      'order_status': 'Placed',
      'orders': cartProducts.map((cartItem) {
        return {
          'title': cartItem['title'],
          'tprice': cartItem['tprice'], // make sure int
          'qty': cartItem['qty'],       // make sure int
          'color': cartItem['color'],   // make sure int
        };
      }).toList(),
    });

  } catch (e) {
    print("Error placing order: $e");
    VxToast.show(Get.context!, msg: "Failed to place order");
  }

  placingOrder.value = false;
}
String generateOrderCode({int length = 8}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}*/

   /*placeMyOrder({orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      "order_code":"233981237",
      "order_date": FieldValue.serverTimestamp(),
      "order_by": currentUser!.uid,
      "order_by_name": Get.find<HomeController>().username.value,
      "order_by_email": currentUser!.email,
      "order_by_address": addressController.text,
      "order_by_state": stateController.text,
      "order_by_city": cityController.text,
      "order_by_phone": phoneController.text,
      "order_by_postalcode": postalcodeController.text,
      "shipping_method": "Home Delivery",
      "payment_method": orderPaymentMethod,
      "order_placed": true,
      "order_confirmed": false,
      "order_delivered": false,
      "order_on_delivery": false,
      "total_amount": totalAmount,
      "orders": FieldValue.arrayUnion(products),
      "vendors" : FieldValue.arrayUnion(vendors),

    }); 
    placingOrder(false);

   }*/

  
  
    clearCart() {
      for (var i = 0; i < productSnapshot. length; i++) {
        firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
      }
    }



    //ADDITIONAL
    Future<int> getCurrentStock(String productId) async {
  final doc = await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get();
  if (!doc.exists) return 0;
  final data = doc.data() as Map<String, dynamic>;
  return data['p_quantity'] ?? 0; // live stock
}





   // Toggle single item selection
   int toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // -------------------- Selection --------------------
  // Toggle a single item
  void toggleSelection(String itemId) {
    if (selectedItems.containsKey(itemId)) {
      selectedItems[itemId] = !selectedItems[itemId]!;
    } else {
      selectedItems[itemId] = true;
    }
    recalcTotal();
  }

  // Toggle select all
  void toggleSelectAll() {
    bool allSelected = selectedItems.values.every((v) => v == true);
    for (var item in productSnapshot) {
      selectedItems[item.id] = !allSelected;
    }
    recalcTotal();
  }

  // -------------------- Total Calculation --------------------
  // Recalculate total price of selected items
  void recalcTotal() {
    totalP.value = 0;
    for (var item in productSnapshot) {
      if (selectedItems[item.id] == true) {
        totalP.value += toInt(item['tprice']) * toInt(item['qty']);
      }
    }
  }

  // Check if all items selected
  bool isAllSelected() {
    if (productSnapshot.isEmpty) return false;
    return selectedItems.values.every((v) => v == true);
  }

  // Check if at least one item selected
  bool hasSelected() {
    return selectedItems.values.any((v) => v == true);
  }

}

  
