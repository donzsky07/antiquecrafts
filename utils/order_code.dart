import 'dart:math';

String generateOrderCode() {
  final random = Random().nextInt(9000) + 1000;

  return "ORD-${DateTime.now().millisecondsSinceEpoch}-$random";
}