import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  var favorites = <bool>[].obs;
  var posts = <Map<String, dynamic>>[].obs;
  var userFavorites = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserFavorites();
      } else {
        resetData();
      }
    });

    posts.listen((List<Map<String, dynamic>> postList) {
      updateFavoritesList();
    });
  }

  void resetData() {
    posts.clear();
    favorites.clear();
    userFavorites.clear();
  }

  void toggleFav(int index) {
    if (index >= favorites.length) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String postId = posts[index]['uid'];
      bool isFavorite = favorites[index];

      favorites[index] = !isFavorite;

      if (favorites[index]) {
        userFavorites.add(postId);
      } else {
        userFavorites.remove(postId);
      }

      updateUserFavorites(user.uid);
    }
  }

  Future<void> updateUserFavorites(String userId) async {
    await FirebaseFirestore.instance
        .collection('InstaUser')
        .doc(userId)
        .update({
      'favorites': userFavorites,
    });
  }

  Future<void> fetchUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('favorites') && data['favorites'] is List) {
          userFavorites.value =
              List<String>.from(data['favorites'] as List<dynamic>);
        } else {
          userFavorites.value = [];
        }

        updateFavoritesList();
      }
    }
  }

  void updateFavoritesList() {
    favorites.value = posts.map((post) {
      return userFavorites.contains(post['uid']);
    }).toList();
  }
}
