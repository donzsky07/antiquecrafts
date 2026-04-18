
/*import 'package:projects/seller/consts/const.dart';

class StoreServices {

  static getProfile(uid) {
    return firestore.collection(vendorsCollection).where('id', isEqualTo: uid).get();
  }

 static getMessages(uid) {
    return firestore.collection(chatsCollection).where('toId', isEqualTo: uid).snapshots();
  }

 /* static getMessages(String uid) {
  return firestore
      .collection(chatsCollection)
      .where('users', arrayContains: uid) // all chats that involve this user
      .orderBy('created_on', descending: true) // show latest chats first
      .snapshots();
}*/



  static getOrders(uid) {
    return firestore.collection(ordersCollection).where('vendors', arrayContains: uid).snapshots();
  }

  static getProducts(uid) {
    return firestore.collection(productsCollection).where('vendor_id', isEqualTo: uid).snapshots();
  }

  //
  




}*/

//NEW line of CODES


import 'package:projects/seller/consts/const.dart';

class StoreServices {

  static getProfile(uid) {
    return firestore.collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getMessages(uid) {
    return firestore.collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static getOrders(uid) {
    return firestore.collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  static getProducts(uid) {
    return firestore.collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  // PRODUCTS RATINGS
  /*static Future<void> updateProductRating(String productId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('product_id', isEqualTo: productId)
        .get();

    if (snapshot.docs.isEmpty) return;

    double total = 0;

    for (var doc in snapshot.docs) {
      total += (doc['rating'] ?? 0);
    }

    double avg = total / snapshot.docs.length;

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'p_ratings': avg,
      'total_reviews': snapshot.docs.length,
    });
  }*/
  

  
}