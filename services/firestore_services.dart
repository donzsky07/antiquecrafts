import 'package:projects/consts/consts.dart';
//import 'package:projects/models/category_model.dart';

class FirestoreServices{
    //get users data
  static getUser(uid){
    return firestore.collection(usersCollection).where('id', isEqualTo: uid).snapshots();

  }
  // get products according to category
  static getProducts(category) {
    return firestore.collection(productsCollection).where('p_category', isEqualTo: category).snapshots();
  }


}