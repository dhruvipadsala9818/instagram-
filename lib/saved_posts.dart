import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SavedPostsPage extends StatelessWidget {
  SavedPostsPage({Key? key}) : super(key: key);

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(
        () {
          if (controller.userBookmarks.isEmpty) {
            return const Center(
              child: Text('No saved posts yet'),
            );
          }

          return ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              String postId = controller.posts[index]['uid'];
              if (!controller.userBookmarks.contains(postId)) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            controller.posts[index]['userProfileImageUrl'] ??
                                'https://via.placeholder.com/150',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          controller.posts[index]['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(controller.posts[index]['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
