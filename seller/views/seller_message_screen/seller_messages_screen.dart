import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:projects/seller/consts/const.dart';
import 'package:projects/seller/services/store_services.dart';
import 'package:projects/seller/views/seller_message_screen/seller_chat_screen.dart';
import 'package:projects/seller/views/seller_widgets/s_loading_indicator.dart';
import 'package:projects/seller/views/seller_widgets/s_text_style.dart';

class SMessagesScreen extends StatelessWidget {
  const SMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: messages, size: 18.0, color: fontGrey),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return sLoadingIndicator();
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(
              child: Text("No chats yet."),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var chat = data[index];
                var t = chat['created_on'] == null
                    ? DateTime.now()
                    : chat['created_on'].toDate();
                var time = intl.DateFormat("h:mma").format(t);

                return ListTile(
                  onTap: () {
                    Get.to(
                      () => const SellerChatScreen(),
                      arguments: [
                        chat['friend_name'], // friendName
                        chat['fromId'],      // friendId
                      ],
                    );
                  },
                  leading: const CircleAvatar(
                    backgroundColor: purpleColor,
                    child: Icon(
                      Icons.person,
                      color: white,
                    ),
                  ),
                  title: boldText(
                      text: "${chat['sender_name']}", color: fontGrey),
                  subtitle: normalText(
                      text: "${chat['last_msg']}", color: darkGrey),
                  trailing: normalText(text: time, color: darkGrey),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:seller_side/consts/const.dart';
import 'package:seller_side/services/store_services.dart';
import 'package:seller_side/views/message_screen/chat_screen.dart';
import 'package:seller_side/views/widgets/loading_indicator.dart';
import 'package:seller_side/views/widgets/text_style.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: messages, size: 18.0, color: fontGrey ),
      ),

      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if(!snapshot.hasData){
            return loadingIndicator();
          }else {

            var data = snapshot.data!.docs;

            return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),            
           child: Column(
            children: List.generate(data.length,(index){ 
              var t = data[index]['created_on'] == null ? DateTime.now() : data[index]['created_on'].toDate();
              var time = intl.DateFormat("h:mma").format(t);
              return ListTile(
             onTap: () {
  Get.to(
    () => const ChatScreen(),
    arguments: [
      data[index]['sender_name'], // friendName
      data[index]['fromId'],      // friendId (user’s UID)
    ],
  );
},

            leading:  const CircleAvatar(
              backgroundColor: purpleColor,
              child: Icon(
                Icons.person, 
                color: white,
                )),
              title: boldText(text: "${data[index]['sender_name']}", color: fontGrey),
                subtitle: normalText(text: "${data[index]['last_msg']}", color: darkGrey),
                trailing: normalText(text: time, color: darkGrey),
          );
          }),
          ),
        ),
       
        );

          }
        },
      ),
    
    );

  }

}*/
