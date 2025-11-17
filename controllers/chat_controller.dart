/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/home_controller.dart';
import 'package:projects/views/chat_screen/components/notification_services.dart';

class ChatController extends GetxController {
  @override
void onInit() {
  super.onInit();            
 // NotificationService.init(); // initialize local notifications
  getChatId();               
}

  var chats = firestore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username.value;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;

  var isloading = false.obs;

  // Step 4: Listen to Firestore messages
  void listenToMessages() {
    if (chatDocId == null) return; // ensure chatDocId is set

    chats.doc(chatDocId).collection(messageCollection).snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          var msgData = change.doc.data() as Map<String, dynamic>;
          // Only notify if the message is from the other user
          if (msgData['uid'] != currentId) {
            NotificationService.showNotification('New Message', msgData['msg']);
          }
        }
      }
    });
  }

  // Get or create chat document
  getChatId() async {
    isloading(true);

    await chats.where('users', isEqualTo: {
      friendId: null,
      currentId: null
    }).limit(1).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
        listenToMessages(); // start listening after chatDocId is set
      } else {
        chats.add({
          "created_on": null,
          "last_msg": '',
          "users": {friendId: null, currentId: null},
          "toId": '',
          "fromId": '',
          "friend_name": friendName,
          "sender_name": senderName
        }).then((value) {
          chatDocId = value.id;
          listenToMessages(); // start listening after chatDocId is set
        });
      }
    });

    isloading(false);
  }

  // Send a message
  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
      });

      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/consts/consts.dart';
import 'package:projects/controllers/home_controller.dart';


class ChatController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username.value;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;

  var isloading = false.obs;

  getChatId() async {
    
    isloading(true);

    await chats.where('users', isEqualTo: {
      friendId: null,
      currentId: null

    }
    ).limit(1).get().then((QuerySnapshot snapshot){
      if(snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
      }else {
        chats.add({
          "created_on": null,
          "last_msg": '',
          "users": {friendId: null, currentId: null},
          "toId": '',
          "fromId": '',
          "friend_name": friendName,
          "sender_name": senderName

        }).then ((value) {
          {
            chatDocId = value.id;
          }
        });
      }
    });
    isloading(false);
  }

  sendMsg(String msg) async {
    if(msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,

      });

      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,

      });

    }
  }



}