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
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isReported', isEqualTo: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                child: ListTile(
                  leading: const Icon(Icons.report, color: Colors.red),
                  title: Text(user['name'] ?? "No name"),
                  subtitle: Text(user['email'] ?? ""),
                  trailing: Text(user['id'] ?? ""),
                ),
              );
            },
          );
        },
      ),
    );
  }
}