import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BlockedPage extends StatelessWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const Text(
          "Blocked Users",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('isBlocked', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;

              if (users.isEmpty) {
                return const Center(child: Text("No blocked users"));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Card(
                    child: ListTile(
                      title: Text(user['name'] ?? 'No Name'),
                      subtitle: Text(user['email'] ?? ''),

                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .update({
                            'isBlocked': false,
                          });
                        },
                        child: const Text("Unblock"),
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
}