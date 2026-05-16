import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projects/admin/views/home_screen/admin_homescreen.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // BACK BUTTON
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // OPTION 1: balik lang sa previous screen
            //Get.back();

            // OPTION 2: diretso dashboard/home (uncomment kung gusto mo)
             Get.offAll(() => const AdminHomeScreen());
          },
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // LIST
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;

                if (orders.isEmpty) {
                  return const Center(child: Text("No orders found"));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final data = order.data() as Map<String, dynamic>;

                    final items = data['orders'] ?? [];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ExpansionTile(
                        title: Text(
                          "Order Code: ${data['order_code'] ?? ''}",
                        ),
                        subtitle: Text(
                          "Name: ${data['order_by_name'] ?? ''}\n"
                          "Total: ₱${(data['total_amount'] as num? ?? 0).toDouble().toStringAsFixed(2)}",
                        ),

                        children: [
                          // CUSTOMER INFO
                          ListTile(
                            title: const Text("Customer Info"),
                            subtitle: Text(
                              "Email: ${data['order_by_email'] ?? ''}\n"
                              "Phone: ${data['order_by_phone'] ?? ''}\n"
                              "Address: ${data['order_by_address'] ?? ''}",
                            ),
                          ),

                          const Divider(),

                          const Text(
                            "Ordered Items",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          ...List.generate(items.length, (i) {
                            final item = items[i];

                            return ListTile(
                              leading: Image.network(
                                item['img'] ?? '',
                                width: 40,
                                height: 40,
                                errorBuilder: (c, e, s) =>
                                    const Icon(Icons.image),
                              ),
                              title: Text(item['title'] ?? ''),
                              subtitle: Text(
                                "Qty: ${item['qty']} | ₱${(item['tprice'] as num? ?? 0).toDouble().toStringAsFixed(2)}",
                              ),
                            );
                          }),

                          const Divider(),

                          // STATUS BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _statusButton(
                                "Confirmed",
                                data['order_confirmed'] ?? false,
                                () => _update(order.id, {
                                  'order_confirmed': true,
                                }),
                              ),
                              _statusButton(
                                "Shipping",
                                data['order_on_delivery'] ?? false,
                                () => _update(order.id, {
                                  'order_on_delivery': true,
                                }),
                              ),
                              _statusButton(
                                "Delivered",
                                data['order_delivered'] ?? false,
                                () => _update(order.id, {
                                  'order_delivered': true,
                                }),
                              ),

                              // DELETE
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "Delete Order?",
                                    middleText:
                                        "This action cannot be undone.",
                                    textConfirm: "Delete",
                                    textCancel: "Cancel",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order.id)
                                          .delete();

                                      Get.back();
                                    },
                                  );
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // UPDATE STATUS
  void _update(String id, Map<String, dynamic> data) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(id)
        .update(data);
  }

  // STATUS BUTTON
  Widget _statusButton(String text, bool value, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: value ? Colors.green : Colors.grey,
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}