import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var allPostsAndReels = <Map<String, dynamic>>[].obs;
  var showSearchResults = false.obs;
  var followingUsers = <String>[].obs;
  var followers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPostsAndReels();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        listenForFollowingUsers();
      } else {
        resetData();
      }
    });
  }

  void resetData() {
    followingUsers.clear();
    followers.clear();
  }

  void listenForFollowingUsers() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('InstaUser')
          .doc(user.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;
          followingUsers.value = List<String>.from(data['following'] ?? []);
          followers.value = List<String>.from(data['followers'] ?? []);
        }
      });
    }
  }

  bool isFollowing(String userId) {
    return followingUsers.contains(userId);
  }

  void toggleFollow(String userId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String currentUserId = user.uid;

      try {
        DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(currentUserId)
            .get();

        DocumentSnapshot targetUserDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userId)
            .get();

        if (!currentUserDoc.exists || !targetUserDoc.exists) {
          print("User document does not exist");
          return;
        }

        List<dynamic> followingList =
            (currentUserDoc.data() as Map<String, dynamic>?)?['following'] ??
                [];
        List<dynamic> followersList =
            (targetUserDoc.data() as Map<String, dynamic>?)?['followers'] ?? [];

        if (followingList.contains(userId)) {
          followingList.remove(userId);
          followersList.remove(currentUserId);
        } else {
          followingList.add(userId);
          if (!followersList.contains(currentUserId)) {
            followersList.add(currentUserId);
          }
        }

        await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(currentUserId)
            .update({'following': followingList});

        await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userId)
            .update({'followers': followersList});

        listenForFollowingUsers();
      } catch (e) {
        print('Error toggling follow: $e');
      }
    }
  }

  void searchUsers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      showSearchResults(false);
      return;
    }

    isLoading(true);
    showSearchResults(true);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('InstaUser')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          'username': doc['username'],
          'email': doc['email'],
          'profileImageUrl': doc['imageUrl'],
          'isFollowing': isFollowing(doc.id),
        };
      }).toList();

      searchResults.assignAll(results);
    } catch (e) {
      print('Error searching users: $e');
    } finally {
      isLoading(false);
    }
  }

  // Fetch both posts and reels from Firestore
  void fetchAllPostsAndReels() {
    isLoading(true);

    // Fetch both posts and reels and combine them in one list
    FirebaseFirestore.instance.collectionGroup('posts').snapshots().listen(
      (snapshot) {
        List<Map<String, dynamic>> allPosts = snapshot.docs.map((doc) {
          return {
            'type': 'image', // Define as post type
            'mediaUrl': doc['mediaUrl'] ?? '',
          };
        }).toList();

        FirebaseFirestore.instance.collectionGroup('reels').snapshots().listen(
          (snapshot) {
            List<Map<String, dynamic>> allReels = snapshot.docs.map((doc) {
              return {
                'type': 'video', // Define as reel type
                'mediaUrl': doc['mediaUrl'] ?? '',
              };
            }).toList();

            allPostsAndReels.assignAll([...allPosts, ...allReels]);
          },
        );
      },
      onError: (e) {
        print('Error fetching posts and reels: $e');
      },
    );

    isLoading(false);
  }
}
