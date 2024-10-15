// // reels_controller.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
//
// class ReelsController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Reactive variables using Rx types
//   var videoUrls = <String>[].obs;
//   var isLoading = true.obs;
//   var error = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchReels();
//   }
//
//   Future<void> fetchReels() async {
//     try {
//       final QuerySnapshot snapshot = await _firestore.collection('reels').get();
//       videoUrls.value =
//           snapshot.docs.map((doc) => doc['videoUrl'] as String).toList();
//       isLoading.value = false;
//     } catch (e) {
//       error.value = e.toString();
//       isLoading.value = false;
//     }
//   }
// }
