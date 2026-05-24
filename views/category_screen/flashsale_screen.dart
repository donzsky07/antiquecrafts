
import 'package:projects/consts/consts.dart';

class FlashSaleScreen extends StatelessWidget {
  const FlashSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: softBlueGreen,
      appBar: AppBar(
         backgroundColor: softBlueGreen,
        title: const Text("Flash Sale"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(
            leading: Icon(Icons.flash_on),
            title: Text("Limited Time Offers"),
            subtitle: Text("Hurry before time runs out!"),
          ),
        ],
      ),
    );
  }
}