import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/constant/app_string.dart';

class CommentController extends GetxController {
  final RxList<QueryDocumentSnapshot> comments = <QueryDocumentSnapshot>[].obs;
  final TextEditingController commentTextController = TextEditingController();
  final RxString userProfileImageUrl = ''.obs;

  void loadComments(String postId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();
    comments.value = snapshot.docs;
  }

  void addComment(String postId) async {
    if (commentTextController.text.isNotEmpty) {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          String username = userData?['username'] ?? AppString.unknownUser;
          String profileImageUrl =
              userData?['imageUrl'] ?? 'https://via.placeholder.com/150';

          await FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('comments')
              .add({
            'comment': commentTextController.text,
            'username': username,
            'profileImageUrl': profileImageUrl,
            'userId': userId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          commentTextController.clear();
          loadComments(postId);
        }
      }
    }
  }

  @override
  void onClose() {
    commentTextController.dispose();
    super.onClose();
  }
}
