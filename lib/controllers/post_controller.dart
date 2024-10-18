import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserController extends ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> reels = [];
  List<Map<String, dynamic>> followers = [];
  List<Map<String, dynamic>> following = [];

  UserController() {
    fetchUserData();
    fetchUserPosts();
    fetchUserReels();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          userData = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
          notifyListeners();
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: user.uid)
            .get();

        print('Number of documents found: ${snapshot.docs.length}');

        if (snapshot.docs.isNotEmpty) {
          posts = snapshot.docs.map((doc) {
            return {'mediaUrl': doc['mediaUrl'], 'uid': doc['uid']};
          }).toList();

          print('Fetched posts: $posts');
        } else {}

        notifyListeners();
      } catch (e) {
        print('Error fetching posts: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> fetchUserReels() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('reels')
            .where('uid', isEqualTo: user.uid)
            .get();

        print('Number of documents found: ${snapshot.docs.length}');

        if (snapshot.docs.isNotEmpty) {
          reels = snapshot.docs.map((doc) {
            return {'mediaUrl': doc['mediaUrl'], 'uid': doc['uid']};
          }).toList();

          print('Fetched posts: $reels');
        } else {}

        notifyListeners();
      } catch (e) {
        print('Error fetching posts: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }
}
