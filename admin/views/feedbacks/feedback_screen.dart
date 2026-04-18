import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "User Feedback",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("ratings")
                  .orderBy("created_at", descending: true)
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No feedback yet"));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index];

                    return feedbackCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 FEEDBACK CARD
  Widget feedbackCard(DocumentSnapshot data) {
    final review = data['review'] ?? "";
    final rating = data['rating'] ?? 0;
    final userId = data['user_id'] ?? "Unknown";
    final timestamp = data['created_at'];

String date = "";

if (timestamp != null) {
  date = DateFormat.yMMMd().format(
    (timestamp as Timestamp).toDate(),
  );
}

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                "User: $userId",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ⭐ RATING
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 18,
                color: index < rating ? Colors.amber : Colors.grey[300],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 💬 REVIEW
          Text(
            review,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 10),

          // 🔥 DELETE BUTTON (optional)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await data.reference.delete();
              },
            ),
          ),
        ],
      ),
    );
  }
}