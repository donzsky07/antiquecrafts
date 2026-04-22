import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Observable list of feedbacks
  var feedbackList = [].obs;

  /// Loading state
  var isLoading = false.obs;

  /// ⭐ Selected Rating
  var selectedRating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  /// 🔥 FETCH ALL FEEDBACKS (REALTIME + FIXED COLLECTION)
  void fetchFeedbacks() {
    isLoading(true);

    firestore
        .collection('feedbacks') // ✅ FIXED (was ratings)
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((snapshot) {
      feedbackList.value = snapshot.docs.map((doc) {
        var data = doc.data();

        return {
          'id': doc.id,
          'product_id': data['product_id'] ?? '',
          'user_id': data['user_id'] ?? '',
          'vendor_id': data['vendor_id'] ?? '',
          'rating': data['rating'] ?? 0.0,
          'review': data['review'] ?? '',
          'status': data['status'] ?? 'pending',
          'isApproved': data['isApproved'] ?? false,
          'isReported': data['isReported'] ?? false,
          'created_at': data['created_at'],
        };
      }).toList();

      isLoading(false);
    });
  }

  /// ✔️ APPROVE FEEDBACK
  Future<void> approveFeedback(String docId) async {
    await firestore.collection('feedbacks').doc(docId).update({
      'isApproved': true,
      'status': 'approved',
    });
  }

  /// 🚨 REPORT FEEDBACK
  Future<void> reportFeedback(String docId) async {
    await firestore.collection('feedbacks').doc(docId).update({
      'isReported': true,
    });
  }

  /// 🗑 DELETE FEEDBACK
  Future<void> deleteFeedback(String docId) async {
    await firestore.collection('feedbacks').doc(docId).delete();
  }

  /// 📊 FILTER BY VENDOR
  List getByVendor(String vendorId) {
    return feedbackList
        .where((item) => item['vendor_id'] == vendorId)
        .toList();
  }

  /// 📦 FILTER BY PRODUCT
  List getByProduct(String productId) {
    return feedbackList
        .where((item) => item['product_id'] == productId)
        .toList();
  }

  /// 🚀 SUBMIT FEEDBACK (WITH VALIDATION + DUPLICATE CHECK)
  Future<void> submitFeedback({
    required String userId,
    required String productId,
    required String vendorId,
    required double rating,
    required String review,
  }) async {
    try {
      isLoading(true);

      // ✅ VALIDATION
      if (review.trim().isEmpty || rating == 0) {
        throw Exception("Review and rating are required");
      }

      // 🔥 OPTIONAL: PREVENT DUPLICATE FEEDBACK
      var existing = await firestore
          .collection('feedbacks')
          .where('user_id', isEqualTo: userId)
          .where('product_id', isEqualTo: productId)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception("You already submitted feedback");
      }

      await firestore.collection('feedbacks').add({
        'user_id': userId,
        'product_id': productId,
        'vendor_id': vendorId,
        'rating': rating,
        'review': review.trim(),
        'created_at': FieldValue.serverTimestamp(),
        'status': 'pending',
        'isApproved': false,
        'isReported': false,
      });

    } finally {
      isLoading(false);
    }
  }
}