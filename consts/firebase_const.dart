/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;
//User? get currentUser => FirebaseAuth.instance.currentUser;
//collections
const usersCollection = "users";
const productsCollection = "products";
const cartCollection = "cart";
const chatsCollection = "chats";
const messageCollection = "message";

<<<<<<< HEAD
const ordersCollection = "orders";*/
=======
const ordersCollection = "orders";



const vendorsCollection = "vendors";*///

>>>>>>> f5bf3bc (v3 in 1)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

<<<<<<< HEAD
=======
// ======================= FIREBASE INSTANCES =======================
>>>>>>> f5bf3bc (v3 in 1)
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

<<<<<<< HEAD
// Collections
const usersCollection = "users";
const productsCollection = "products";
const cartCollection = "cart";

const chatsCollection = "chats";
const messageCollection = "messages";
const ordersCollection = "orders";
const ratingsCollection = "ratings";

=======
// ======================= COMMON COLLECTIONS ======================

const vendorsCollection = "vendors";
const productsCollection = "products";
const ordersCollection = "orders";
const chatsCollection = "chats";
const messageCollection = "message";

// ======================= USER COLLECTIONS ========================
const usersCollection = "users";
const cartCollection = "cart";

// ======================= SELLER COLLECTIONS ======================
// (Kung may future-specific seller-only collections, ilalagay dito)
>>>>>>> f5bf3bc (v3 in 1)
