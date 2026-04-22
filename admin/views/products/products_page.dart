import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🔥 HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Products",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            ElevatedButton.icon(
              onPressed: () => showAddProductDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 🔥 PRODUCT LIST
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!.docs;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag),

                      // ✅ FIXED FIELD NAME
                      title: Text(product['p_name'] ?? "No Name"),

                      subtitle: Text("₱${product['price'] ?? 0}"),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ✏ EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showEditProductDialog(
                                context,
                                product.id,
                                product,
                              );
                            },
                          ),

                          // 🗑 DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(product.id)
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

  // ➕ ADD PRODUCT
  void showAddProductDialog(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController price = TextEditingController();

    Get.defaultDialog(
      title: "Add Product",
      content: Column(
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(hintText: "Product Name"),
          ),
          TextField(
            controller: price,
            decoration: const InputDecoration(hintText: "Price"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      textConfirm: "Save",
      onConfirm: () {
        FirebaseFirestore.instance.collection('products').add({
          'p_name': name.text, // ✅ FIXED
          'p_price': double.tryParse(price.text) ?? 0,
          'created_at': DateTime.now(),
        });

        Get.back();
      },
    );
  }

  // ✏ EDIT PRODUCT
  void showEditProductDialog(
      BuildContext context, String id, dynamic data) {

    TextEditingController name =
        TextEditingController(text: data['p_name']); // ✅ FIXED

    TextEditingController price =
        TextEditingController(text: data['p_price'].toString());

    Get.defaultDialog(
      title: "Edit Product",
      content: Column(
        children: [
          TextField(controller: name),
          TextField(controller: price),
        ],
      ),
      textConfirm: "Update",
      onConfirm: () {
        FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .update({
          'p_name': name.text, // ✅ FIXED
          'p_price': double.tryParse(price.text) ?? 0,
        });

        Get.back();
      },
    );
  }
}