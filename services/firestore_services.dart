import 'package:projects/consts/consts.dart';


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

  static getSubCategoryProducts(title){
     return firestore
    .collection(productsCollection)
    .where('p_subcategory', isEqualTo: title)
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

static getWishlists(){
  return firestore.collection(productsCollection).where("p_wishlist", arrayContains: currentUser!.uid).snapshots();
}

static getAllMessages() {
   return firestore.collection(chatsCollection).where("fromId", isEqualTo: currentUser!.uid).snapshots();

}

static getCount() async {
  var res = await Future.wait({
    firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value){
      return value.docs.length;
    }),
    firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).get().then((value){
      return value.docs.length;
    }),
    firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).get().then((value){
      return value.docs.length;
    })
  });
  return res;
}

static allproducts() {
  return firestore.collection(productsCollection).snapshots();
}

//get featured products method
static getFeaturedProducts(){
  return firestore.collection(productsCollection).where('is_featured', isEqualTo: true).get();

}
static searchProducts(title){
  return firestore.collection(productsCollection).get();
}




}


/*import 'package:projects/consts/consts.dart';

class FirestoreServices {
  // ======================= FIRESTORE INSTANCE =======================
 
  /*static final _firestore = firestore;
  static final _auth = auth;
  static User? get currentUser => _auth.currentUser;*/

  // ======================= USER FUNCTIONS ==========================
  
  // Get user data
  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // Get products by category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  // Get products by subcategory
  static getSubCategoryProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  // Get cart items for user
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  // Delete document in cart
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  // Get all chat messages for a document
  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  // Get all orders for current user
  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where("order_by", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // Get wishlist items for current user
  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where("p_wishlist", arrayContains: currentUser!.uid)
        .snapshots();
  }

  // Get all messages from current user
  static getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where("fromId", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // Get counts: cart, wishlist, orders
  static Future<List<int>> getCount() async {
    var cartCount = await firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: currentUser!.uid)
        .get()
        .then((value) => value.docs.length);

    var wishlistCount = await firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .get()
        .then((value) => value.docs.length);

    var ordersCount = await firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .get()
        .then((value) => value.docs.length);

    return [cartCount, wishlistCount, ordersCount];
  }

  // Get all products
  static allProducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  // Get featured products
  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  // Search products (currently returns all)
  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  // ======================= SELLER FUNCTIONS ==========================
  
  // Get seller profile by uid
  static getSellerProfile(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  // Get seller messages by uid
  static getSellerMessages(uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  // Get seller orders by uid
  static getSellerOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  // Get seller products by uid
  static getSellerProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

}*/