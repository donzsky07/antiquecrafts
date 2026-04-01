import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

const vendorsCollection = "vendors";
const usersCollection = "users"; // shared (role = seller)
const productsCollection = "products";

const chatsCollection = "chats";
<<<<<<< HEAD
const messageCollection = "messages";
const ordersCollection = "orders";


/*const productsCollection = "products";
const chatsCollection = "chats";
const messageCollection = "messages";
const ordersCollection = "orders";*/
=======
const messageCollection = "message";
const ordersCollection = "orders";
>>>>>>> f5bf3bc (v3 in 1)
