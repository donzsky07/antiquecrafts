import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // 🔥 HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Users",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

           ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, 
    foregroundColor: Colors.white, 
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  onPressed: () {
    showAddUserDialog(context);
  },
  child: const Text("Add User"),
),
          ],
        ),

        const SizedBox(height: 20),

        // 🔥 USER LIST
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Card(
                    child: ListTile(
                      title: Text(user['name'] ?? "No Name"),
                      subtitle: Text(user['email'] ?? ""),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ✏ EDIT
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showEditUserDialog(context, user.id, user);
                            },
                          ),

                          // 🗑 DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ➕ ADD USER
  void showAddUserDialog(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();

    Get.defaultDialog(
      title: "Add User",
      content: Column(
        children: [
          TextField(controller: name, decoration: const InputDecoration(hintText: "Name")),
          TextField(controller: email, decoration: const InputDecoration(hintText: "Email")),
        ],
      ),
      textConfirm: "Save",
      onConfirm: () {
        FirebaseFirestore.instance.collection('users').add({
          'name': name.text,
          'email': email.text,
        });
        Get.back();
      },
    );
  }

  // ✏ EDIT USER
  void showEditUserDialog(BuildContext context, String id, dynamic data) {
    TextEditingController name = TextEditingController(text: data['name']);
    TextEditingController email = TextEditingController(text: data['email']);

    Get.defaultDialog(
      title: "Edit User",
      content: Column(
        children: [
          TextField(controller: name),
          TextField(controller: email),
        ],
      ),
      textConfirm: "Update",
      onConfirm: () {
        FirebaseFirestore.instance.collection('users').doc(id).update({
          'name': name.text,
          'email': email.text,
        });
        Get.back();
      },
    );
  }
}