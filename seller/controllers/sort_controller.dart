import 'package:get/get.dart';

class SortController extends GetxController {
  var selectedSort = "Popular".obs;

  void changeSort(String value) {
    selectedSort.value = value;
  }
}