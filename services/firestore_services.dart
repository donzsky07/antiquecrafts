import 'package:projects/consts/consts.dart';
//import 'package:projects/models/category_model.dart';

class FirestoreServices{
    //get users data
  static getUser(uid){
    return firestore
    .collection(usersCollection)
    .where('id', isEqualTo: uid)
    .snapshots();

  }
  // get products according to category
  static getProducts(category) {
    return firestore
    .collection(productsCollection)
    .where('p_category', isEqualTo: category)
    .snapshots();
  }

  //get cart
static getcart(uid){
  return firestore
  .collection(cartCollection)
  .where('added_by', isEqualTo: uid)
  .snapshots();
}

//delete document in shopping cart
static deleteDocument(docId) {
  return firestore.collection(cartCollection).doc(docId).delete();

}

//get all chat messages
static getChatMessages(docId){
  return firestore
  .collection(chatsCollection)
  .doc(docId)
  .collection(messageCollection)
  .orderBy('created_on', descending: false)
  . snapshots();
}

static getAllOrders() {
  return firestore.collection(ordersCollection).where("order_by",isEqualTo: currentUser!.uid).snapshots();
}

}