import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

const vendorsCollection = "vendors";
const productsCollection = "products";
const chatsCollection = "chats";
const messageCollection = "messages";
const ordersCollection = "orders";