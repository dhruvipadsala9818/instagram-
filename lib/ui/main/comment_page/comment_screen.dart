import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/comment_controller.dart';
import '../bottombar/bottom_nav_bar.dart';

class CommentScreen extends StatelessWidget {
  final String postId;
  final CommentController controller = Get.put(CommentController());

  CommentScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
    });

    return Scaffold(
      body: BottomNavBar(),
      resizeToAvoidBottomInset: true,
    );
  }

  void _showBottomSheet(BuildContext context) async {
    controller.loadComments(postId);

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
            postId: postId,
            scrollController: scrollController,
            controller: controller,
          );
        },
      ),
    );
  }
}

class BottomCommentSheet extends StatelessWidget {
  final String postId;
  final ScrollController scrollController;
  final CommentController controller;

  BottomCommentSheet({
    required this.postId,
    required this.scrollController,
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
          // Drag handle
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
            child: Obx(
              () => controller.comments.isNotEmpty
                  ? SingleChildScrollView(
                      controller: scrollController,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.comments.length,
                        itemBuilder: (context, index) {
                          var commentData = controller.comments[index].data()
                              as Map<String, dynamic>;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                commentData.containsKey('profileImageUrl')
                                    ? commentData['profileImageUrl']
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                            title: Text(
                              commentData.containsKey('username')
                                  ? commentData['username']
                                  : 'Unknown User',
                            ),
                            subtitle: Text(commentData['comment']),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text('No comments yet, be the first!'),
                    ),
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(left: 8),
                  child: Obx(
                    () => CachedNetworkImage(
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
                      controller: controller.commentTextController,
                      decoration: InputDecoration(
                        hintText: AppString.typeYourComment,
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) {
                        controller.addComment(postId);
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    controller.addComment(postId);
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
