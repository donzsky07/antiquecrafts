import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() =>
      _UsersManagementScreenState();
}

class _UsersManagementScreenState
    extends State<UsersManagementScreen>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(48, 176, 199, 1),

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 176, 199, 1),
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Users Management",
          style: TextStyle(color: Colors.white),
        ),

        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Active"),
            Tab(text: "Blocked"),
          ],
        ),
      ),

      body: TabBarView(
        controller: tabController,
        children: [
          /// 👥 ALL USERS
          buildUsersStream(null),

          /// 🟢 ACTIVE USERS
          buildUsersStream(false),

          /// 🚫 BLOCKED USERS
          buildUsersStream(true),
        ],
      ),
    );
  }

  /// 🔥 COMMON USER LIST BUILDER
  Widget buildUsersStream(bool? isBlocked) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var users = snapshot.data!.docs;

        /// FILTER LOGIC
        if (isBlocked != null) {
          users = users.where((user) {
            return (user['isBlocked'] ?? false) ==
                isBlocked;
          }).toList();
        }

        if (users.isEmpty) {
          return const Center(
            child: Text(
              "No users found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          padding: const EdgeInsets.all(12),

          itemBuilder: (context, index) {
            var user = users[index];

            bool blocked = user['isBlocked'] ?? false;

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: blocked
                      ? Colors.red
                      : Colors.green,
                  child: Icon(
                    blocked
                        ? Icons.block
                        : Icons.person,
                    color: Colors.white,
                  ),
                ),

                title: Text(user['name'] ?? "No name"),
                subtitle: Text(user['email'] ?? ""),

               trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [

    /// 🚨 REPORT USER
    IconButton(
      icon: const Icon(
        Icons.report,
        color: Colors.orange,
      ),

      onPressed: () async {

        await FirebaseFirestore.instance
            .collection('reports')
            .add({

          'reportedUserId': user['id'],
          'reportedUserName': user['name'],
          'reason': 'Reported by seller',

          'reportedBy': 'Seller',

          'timestamp':
              FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "User reported successfully",
            ),
          ),
        );
      },
    ),

    /// 🚫 BLOCK / UNBLOCK
    blocked
        ? IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),

            onPressed: () async {

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user['id'])
                  .update({

                'isBlocked': false,
                'blockedAt': null,
                'blockedReason': null,
              });
            },
          )
        : IconButton(
            icon: const Icon(
              Icons.block,
              color: Colors.black,
            ),

            onPressed: () async {

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user['id'])
                  .update({

                'isBlocked': true,
                'blockedAt':
                    FieldValue.serverTimestamp(),

                'blockedReason':
                    'Blocked by seller',
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
    );
  }
}