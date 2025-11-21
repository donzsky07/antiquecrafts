
import 'package:projects/seller/consts/const.dart';

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




}