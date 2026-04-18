import 'package:get/get.dart';

class AdminNavController extends GetxController {
  var index = 0.obs;

  void changePage(int i) {
    index.value = i;
  }
}