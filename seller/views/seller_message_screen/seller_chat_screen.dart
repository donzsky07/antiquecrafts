import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/controllers/chat_controller.dart';
import 'package:projects/seller/views/seller_message_screen/components/seller_chat_bubble.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SellerChatScreen extends StatelessWidget {
  const SellerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SellerChatController ctrl = Get.put(SellerChatController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fontGrey),
          onPressed: () => Get.back(),
        ),
        title: boldText(text: ctrl.friendName, size: 18.0, color: fontGrey),
      ),
      body: Obx(() {
        if (ctrl.isloading.value) {
          return sLoadingIndicator();
        }
        return Column(
          children: [
            // Messages list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ctrl.chats
                    .doc(ctrl.chatDocId)
                    .collection(messageCollection)
                    .orderBy('created_on', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return sLoadingIndicator();
                  }

                  final messages = snapshot.data!.docs;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text("No messages yet. Say hi!"),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final data = msg.data() as Map<String, dynamic>;
                      final msgText = data['msg'] ?? '';
                      final senderId = data['uid'] ?? '';
                      final t = data['created_on'] == null
                          ? DateTime.now()
                          : (data['created_on'] as Timestamp).toDate();
                      final time = intl.DateFormat("h:mma").format(t);
                      final isMe = senderId == ctrl.currentId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: sellerChatBubble(
                          message: msgText,
                          isMe: isMe,
                          time: time,
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Input area
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ctrl.msgController,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Enter message....",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: purpleColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: purpleColor),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final msg = ctrl.msgController.text.trim();
                      if (msg.isNotEmpty) {
                        ctrl.sendMsg(msg);
                        ctrl.msgController.clear();
                      }
                    },
                    icon: const Icon(Icons.send, color: purpleColor),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}



/*import 'package:get/get.dart';
import 'package:seller_side/consts/const.dart';
import 'package:seller_side/views/message_screen/components/chat_bubble.dart';
import 'package:seller_side/views/widgets/text_style.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: fontGrey),
        onPressed: (){
          Get.back();
        },
      ),
        title: boldText(text: chats, size: 18.0, color: fontGrey ),
       ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder:((context, index){
                  return chatBubble();
                }),
              ),
            ),
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration( 
                    isDense: true,
                    hintText: "Enter message....",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: purpleColor 
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: purpleColor 
                      ),
                    ),
                    ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send, color: purpleColor)),
          ],
        ),
      ),
    ],
    ),
    ),
    );
    
  
  }
}*/