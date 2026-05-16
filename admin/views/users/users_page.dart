import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String selectedFilter = "All"; // All | Active | Blocked

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // 🔥 HEADER WITH BACK BUTTON
        Row(
          children: [

            // ← BACK BUTTON
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // OPTION 1: balik sa previous page
                Get.back();

                // OPTION 2: diretso dashboard/home
                // Get.offAll(() => const DashboardScreen());
              },
            ),

            const Text(
              "Users",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const Spacer(),

            // 🟢 ADD USER BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => showAddUserDialog(context),
              child: const Text("Add User"),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 🔥 FILTER TABS
        Row(
          children: [
            filterButton("All"),
            const SizedBox(width: 10),
            filterButton("Active"),
            const SizedBox(width: 10),
            filterButton("Blocked"),
          ],
        ),

        const SizedBox(height: 20),

        // 🔥 USER LIST
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;

              final filteredUsers = users.where((user) {
                final data = user.data();
                final isBlocked = data['isBlocked'] ?? false;

                if (selectedFilter == "All") return true;
                if (selectedFilter == "Active") return isBlocked == false;
                if (selectedFilter == "Blocked") return isBlocked == true;

                return true;
              }).toList();

              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final data = user.data();
                  final isBlocked = data['isBlocked'] ?? false;

                  return Card(
                    color: isBlocked ? Colors.red.shade50 : null,
                    child: ListTile(
                      leading: Icon(
                        isBlocked ? Icons.block : Icons.person,
                        color:
                            isBlocked ? Colors.red : Colors.green,
                      ),
                      title: Text(
                        data['name'] ?? "No Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isBlocked ? Colors.red : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['email'] ?? ""),

                          if (isBlocked) ...[
                            const SizedBox(height: 4),
                            const Text(
                              "BLOCKED USER",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Reason: ${data['blockedReason'] ?? 'No reason'}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Blocked At: ${data['blockedAt'] != null ? data['blockedAt'].toDate().toString() : 'N/A'}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ],
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showEditUserDialog(
                                  context, user.id, data);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .delete();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isBlocked
                                  ? Icons.lock_open
                                  : Icons.lock,
                              color: isBlocked
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .update({
                                'isBlocked': !isBlocked,
                                'blockedReason': isBlocked
                                    ? ''
                                    : 'Blocked by admin',
                                'blockedAt': isBlocked
                                    ? null
                                    : FieldValue.serverTimestamp(),
                              });
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

  // 🔥 FILTER BUTTON
  Widget filterButton(String title) {
    final isSelected = selectedFilter == title;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.black : Colors.grey.shade300,
        foregroundColor:
            isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Text(title),
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
          TextField(controller: name),
          TextField(controller: email),
        ],
      ),
      textConfirm: "Save",
      onConfirm: () {
        FirebaseFirestore.instance.collection('users').add({
          'name': name.text,
          'email': email.text,
          'role': 'user',
          'cart_count': 0,
          'wishlist_count': 0,
          'order_count': 0,
          'isBlocked': false,
          'blockedReason': '',
          'blockedAt': null,
        });

        Get.back();
      },
    );
  }

  // ✏ EDIT USER
  void showEditUserDialog(
      BuildContext context, String id, dynamic data) {
    TextEditingController name =
        TextEditingController(text: data['name']);
    TextEditingController email =
        TextEditingController(text: data['email']);

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
        FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .update({
          'name': name.text,
          'email': email.text,
        });

        Get.back();
      },
    );
  }
}