import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/consts/colors.dart';

class ProductDetailPage extends StatelessWidget {
  final dynamic product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
    
        title: Text(product['p_name'] ?? "Product Details"),
       backgroundColor: softBlueGreen,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 📸 IMAGE
            Image.network(
              product['p_imgs'][0],
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            // 🏷 NAME
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product['p_name'] ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 💰 PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "₱${(product['p_price'] as num? ?? 0).toDouble().toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📦 STOCK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Stock: ${product['p_quantity'] ?? 0}",
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const Divider(),

            // 🧠 HISTORICAL BACKGROUND
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Historical Background",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product['historical_background'] ?? "No history available for this product.",
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 15),

            // 🎨 FEATURED ARTIST
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Featured Artist",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product['featured_artist'] ?? "Unknown artist",
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),

            // 🛒 ADD TO CART BUTTON (BASIC)
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                   backgroundColor: softBlueGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                ),
                onPressed: () {
        
                  Get.snackbar(
                    "Added",
                    "Product added to cart",
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Add to Cart"),
             
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}