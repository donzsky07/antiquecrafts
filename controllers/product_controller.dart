

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

  int productPrice = 0;

  // -------------------- CATEGORIES --------------------
  getSubCategories(String title) async {
    subcat.clear();
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var decoded = categoryModelFromJson(data);

    var s = decoded.categories
        .where((element) => element.name == title)
        .toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(int index) {
    colorIndex.value = index;
  }

  // -------------------- STOCK FETCH (IMPORTANT FIX) --------------------
  Future<void> fetchProductStock(String productId) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('products').doc(productId).get();

      if (doc.exists) {
        remainingStock.value = doc['p_quantity'] ?? 0;
      }
    } catch (e) {
      VxToast.show(Get.context!, msg: "Failed to load stock");
    }
  }

  // Optional realtime listener (recommended for live updates)
  void listenToStock(String productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        remainingStock.value = doc['p_quantity'] ?? 0;
      }
    });
  }

  // -------------------- PRICE --------------------
  void setProductPrice(int price) {
    productPrice = price;
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice.value = productPrice * quantity.value;
  }

  // -------------------- QUANTITY CONTROL (FIXED LOGIC) --------------------
  void increaseQuantity() {
    if (remainingStock.value > 0) {
      quantity.value++;
      remainingStock.value--;
      calculateTotalPrice();
    } else {
      VxToast.show(Get.context!, msg: "No more items available");
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
      remainingStock.value++;
      calculateTotalPrice();
    }
  }

  // -------------------- RESET --------------------
  void resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  // -------------------- CART --------------------
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
      DocumentSnapshot productSnap =
          await FirebaseFirestore.instance.collection('products').doc(productId).get();

      if (!productSnap.exists) {
        VxToast.show(context, msg: "Product not found");
        return;
      }

      int currentStock = productSnap['p_quantity'] ?? 0;

      if (qty <= 0) {
        VxToast.show(context, msg: "Minimum 1 product is required");
        return;
      }

      if (qty > currentStock) {
        VxToast.show(context, msg: "Not enough stock available");
        return;
      }

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

      await firestore.collection('products').doc(productId).update({
        'p_quantity': currentStock - qty
      });

      resetValues();

      VxToast.show(context, msg: "Added to Cart");
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  // -------------------- WISHLIST --------------------
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
    if (data['p_wishlist'] != null &&
        data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}