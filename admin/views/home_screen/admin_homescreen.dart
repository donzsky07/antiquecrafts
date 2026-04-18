import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects/admin/consts/colors.dart';
import 'package:projects/admin/views/feedbacks/feedback_screen.dart';


class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;

  Future<int> getCount(String collection) async {
    final snap =
        await FirebaseFirestore.instance.collection(collection).get();
    return snap.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          // 🔥 SIDEBAR
          Container(
            width: 250,
            color: softBlue,
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  "ANTIQUE CRAFTS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                sideItem(Icons.dashboard, "Dashboard", 0),
                sideItem(Icons.people, "Users", 1),
                sideItem(Icons.shopping_bag, "Products", 2),
                sideItem(Icons.shopping_cart, "Orders", 3),
                sideItem(Icons.star, "Ratings", 4),
                sideItem(Icons.feedback, "Feedback", 5),
                sideItem(Icons.block, "Blocked", 6),
              ],
            ),
          ),

          // 🔥 MAIN CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),

              child: Builder(
                builder: (context) {
                  if (index == 0) {
                    return dashboardContent();
                  } else if (index == 5) {
                    return const FeedbackScreen();
                        
                  } else if (index == 6) {
                    return const Center(
                        child: Text("Blocked Users Page"));
                  } else {
                    return const Center(
                        child: Text("Page under construction"));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 DASHBOARD CONTENT
  Widget dashboardContent() {
    return FutureBuilder(
      future: Future.wait([
        getCount("users"),
        getCount("products"),
        getCount("orders"),
        getCount("ratings"),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final users = data[0];
        final products = data[1];
        final orders = data[2];
        final ratings = data[3];

        return Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dashboardCard("Users", users, Icons.people, usersColor),
                const SizedBox(width: 20),

                dashboardCard("Products", products, Icons.shopping_bag, productsColor),
                const SizedBox(width: 20),

                dashboardCard("Orders", orders, Icons.shopping_cart, ordersColor),
                const SizedBox(width: 20),

                dashboardCard("Ratings", ratings, Icons.star, ratingsColor),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔥 SIDEBAR ITEM
  Widget sideItem(IconData icon, String title, int i) {
    bool selected = index == i;

    return GestureDetector(
      onTap: () {
        setState(() {
          index = i;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? selectedItemColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // 🔥 DASHBOARD CARD
  Widget dashboardCard(
      String title, int count, IconData icon, Color color) {
    return Container(
      width: 250,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),

      padding: const EdgeInsets.all(20),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 35, color: Colors.white),
          ),
        ],
      ),
    );
  }
}