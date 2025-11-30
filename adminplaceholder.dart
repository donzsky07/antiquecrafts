import 'package:flutter/material.dart';

class AdminPlaceholder extends StatelessWidget {
  const AdminPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Admin Dashboard (Placeholder)"),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Text(
          "Admin Panel Placeholder\n(Web version coming soon)",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
