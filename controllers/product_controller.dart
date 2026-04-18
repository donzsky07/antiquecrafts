import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/models/category_model.dart';


class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs; 
  var totalPrice = 0.obs;

  var subcat = [];
  var isFav = false.obs;

  var rating = 0.obs;

  // Stock tracking
  var remainingStock = 0.obs;

  // -------------------- Categories --------------------
  getSubCategories(String title) async {
    subcat.clear();
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var decoded = categoryModelFromJson(data);
    var s = decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(int index) {
    colorIndex.value = index;
  }

  // -------------------- Quantity & Stock --------------------
  void setInitialStock(int stock) {
    remainingStock.value = stock;
  }
int productPrice = 0;

void setProductPrice(int price) {
  productPrice = price;
  calculateTotalPrice(); // initial compute
}

void increaseQuantity() {
  if (remainingStock.value > 0) {
    quantity.value++;
    remainingStock.value--;
    calculateTotalPrice(); // ✅ update
  } else {
    VxToast.show(Get.context!, msg: "No more items available");
  }
}

void decreaseQuantity() {
  if (quantity.value > 0) {
    quantity.value--;
    remainingStock.value++;
    calculateTotalPrice(); // ✅ update
  }
}

void calculateTotalPrice() {
  totalPrice.value = productPrice * quantity.value;
}

  void updateRemainingStock(int stock) {
    remainingStock.value = stock;
  }

  void resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  // -------------------- Cart --------------------
  addToCart({
    required String title,
    required String img,
    required String sellername,
    required String color,
    required int qty,
    required int tprice,
    required BuildContext context,
    required String vendorID,
    required String productId,
  }) async {
    try {
      // 1️⃣ Fetch product document
      DocumentSnapshot productSnap = await firestore.collection('products').doc(productId).get();
      if (!productSnap.exists) {
        VxToast.show(context, msg: "Product not found");
        return;
      }

      int currentStock = productSnap['p_quantity'] ?? 0;

      // 2️⃣ Check minimum quantity
      if (qty <= 0) {
        VxToast.show(context, msg: "Minimum 1 product is required");
        return;
      }

      // 3️⃣ Check stock availability
      if (qty > currentStock) {
        VxToast.show(context, msg: "Not enough stock available");
        return;
      }

      // 4️⃣ Add item to cart
      await firestore.collection(cartCollection).add({
        "title": title,
        "img": img,
        "sellername": sellername,
        "color": color,
        "qty": qty,
        "vendor_id": vendorID,
        "tprice": tprice,
        "added_by": currentUser!.uid,
        "productId": productId,
      });

      // 5️⃣ Update product stock
      await firestore.collection('products').doc(productId).update({
        'p_quantity': currentStock - qty
      });

      // 6️⃣ Reset controller values
      resetValues();

      VxToast.show(context, msg: "Added to Cart");
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  // -------------------- Wishlist --------------------
  addToWishlist(String docId, BuildContext context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeFromWishlist(String docId, BuildContext context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkIfFav(data) {
    if (data['p_wishlist'] != null && data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }






}