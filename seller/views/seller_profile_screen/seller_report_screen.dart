import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportedUsersScreen extends StatelessWidget {
  const ReportedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(48, 176, 199, 1),

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 176, 199, 1),

        title: const Text(
          "Reported Users",
          style: TextStyle(color: Colors.white),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .orderBy(
              'timestamp',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No reported users",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(12),

            itemBuilder: (context, index) {

              var user = data[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(10),

                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,

                    child: Icon(
                      Icons.report,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    user['reportedUserName']
                            ?? "No name",

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const SizedBox(height: 5),

                      Text(
                        "Reason: ${user['reason'] ?? 'No reason'}",
                      ),

                      const SizedBox(height: 3),

                      Text(
                        "Reported By: ${user['reportedBy'] ?? 'Unknown'}",
                      ),
                    ],
                  ),

                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [

                      /// 🚫 BLOCK USER
                      const PopupMenuItem(
                        value: 'block',
                        child: Text("Block User"),
                      ),

                      /// 🗑 DELETE REPORT
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete Report"),
                      ),
                    ],

                    onSelected: (value) async {

                      /// 🚫 BLOCK USER
                      if (value == 'block') {

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(
                              user['reporteduserId'],
                            )
                            .update({

                          'isBlocked': true,

                          'blockedAt':
                              FieldValue.serverTimestamp(),

                          'blockedReason':
                              'Blocked due to reports',
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "User blocked successfully",
                            ),
                          ),
                        );
                      }

                      /// 🗑 DELETE REPORT
                      if (value == 'delete') {

                        await FirebaseFirestore.instance
                            .collection('reports')
                            .doc(user.id)
                            .delete();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Report deleted",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}