// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import 'bottom_nav_bar.dart';
// import 'controllers/home_controller.dart';
//
// class CommentScreen extends StatefulWidget {
//   final HomeController controller = Get.find();
//
//   final String postId;
//
//   CommentScreen({required this.postId});
//
//   @override
//   _CommentScreenState createState() => _CommentScreenState();
// }
//
// class _CommentScreenState extends State<CommentScreen> {
//   final TextEditingController _controller = TextEditingController();
//   List<QueryDocumentSnapshot> comments = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//   }
//
//   void _loadComments() {
//     FirebaseFirestore.instance
//         .collection('posts')
//         .doc(widget.postId)
//         .collection('comments')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       setState(() {
//         comments = snapshot.docs;
//       });
//     });
//   }
//
//   void _addComment() async {
//     if (_controller.text.isNotEmpty) {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//
//       if (currentUser != null) {
//         String userId = currentUser.uid;
//
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('InstaUser')
//             .doc(userId)
//             .get();
//
//         if (userDoc.exists) {
//           Map<String, dynamic>? userData =
//               userDoc.data() as Map<String, dynamic>?;
//
//           print('User Data: $userData');
//
//           String username = userData?['username'] ?? 'Unknown User';
//           String profileImageUrl =
//               userData?['imageUrl'] ?? 'https://via.placeholder.com/150';
//
//           await FirebaseFirestore.instance
//               .collection('posts')
//               .doc(widget.postId)
//               .collection('comments')
//               .add({
//             'comment': _controller.text,
//             'username': username,
//             'profileImageUrl': profileImageUrl,
//             'userId': userId,
//             'timestamp': FieldValue.serverTimestamp(),
//           });
//
//           _controller.clear();
//         } else {
//           print('User document does not exist.');
//         }
//       } else {
//         print('No user is currently logged in.');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('comments'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(5),
//         child: Column(
//           children: [
//             Expanded(
//               child: comments.isEmpty
//                   ? Center(child: Text('No comments yet.'))
//                   : ListView.builder(
//                       itemCount: comments.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                               (comments[index].data() as Map<String, dynamic>)
//                                       .containsKey('profileImageUrl')
//                                   ? comments[index][
//                                       'profileImageUrl'] // Change to 'profileImageUrl'
//                                   : 'https://via.placeholder.com/150',
//                             ),
//                           ),
//                           title: Text(
//                             (comments[index].data() as Map<String, dynamic>)
//                                     .containsKey('username')
//                                 ? comments[index]['username']
//                                 : 'Unknown User',
//                           ),
//                           subtitle: Text(comments[index]['comment']),
//                         );
//                       },
//                     ),
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: 50,
//                   width: 50,
//                   child: CachedNetworkImage(
//                     imageUrl: controller.userProfileImageUrl.value.isNotEmpty
//                         ? controller.userProfileImageUrl.value
//                         : 'https://via.placeholder.com/150',
//                     imageBuilder: (context, imageProvider) => Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: imageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     placeholder: (context, url) =>
//                         const CircularProgressIndicator(),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(30)),
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         hintText: 'Type your comment...',
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(Icons.send),
//                           onPressed: _addComment,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'bottom_nav_bar.dart';
import 'controllers/home_controller.dart';
import 'home_page.dart';

class CommentScreen extends StatefulWidget {
  final HomeController controller = Get.find();
  final String postId;

  CommentScreen({required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  List<QueryDocumentSnapshot> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  void _loadComments() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        comments = snapshot.docs;
      });
    });
  }

  void _addComment() async {
    if (_controller.text.isNotEmpty) {
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

          String username = userData?['username'] ?? 'Unknown User';
          String profileImageUrl =
              userData?['imageUrl'] ?? 'https://via.placeholder.com/150';

          await FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .add({
            'comment': _controller.text,
            'username': username,
            'profileImageUrl': profileImageUrl,
            'userId': userId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          _controller.clear();
        }
      }
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return BottomCommentSheet(
            postId: widget.postId,
            scrollController: scrollController,
            comments: comments,
            addComment: _addComment,
            textController: _controller,
            controller: widget.controller,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavBar(),
      resizeToAvoidBottomInset: true,
    );
  }
}

class BottomCommentSheet extends StatelessWidget {
  final String postId;
  final ScrollController scrollController;
  final List<QueryDocumentSnapshot> comments;
  final VoidCallback addComment;
  final TextEditingController textController;
  final HomeController controller;

  BottomCommentSheet({
    required this.postId,
    required this.scrollController,
    required this.comments,
    required this.addComment,
    required this.textController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (comments[index].data() as Map<String, dynamic>)
                                    .containsKey('profileImageUrl')
                                ? comments[index]['profileImageUrl']
                                : 'https://via.placeholder.com/150',
                          ),
                        ),
                        title: Text(
                          (comments[index].data() as Map<String, dynamic>)
                                  .containsKey('username')
                              ? comments[index]['username']
                              : 'Unknown User',
                        ),
                        subtitle: Text(comments[index]['comment']),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(left: 8),
                  child: CachedNetworkImage(
                    imageUrl: controller.userProfileImageUrl.value.isNotEmpty
                        ? controller.userProfileImageUrl.value
                        : 'https://via.placeholder.com/150',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),

                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Type your comment...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) {
                        addComment();
                        textController.clear();
                      },
                    ),
                  ),
                ),

                // Send button
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    addComment();
                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
