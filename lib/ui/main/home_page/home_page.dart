import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/constant/app_assets.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/home_controller.dart';
import 'package:instagram/ui/main/comment_page/comment_screen.dart';
import 'package:instagram/ui/main/home_page/view_story.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.instagramText,
                      scale: 3.5,
                    ),
                    const Icon(Icons.keyboard_arrow_down_outlined),
                    const Spacer(),
                    const Icon(Icons.favorite_border),
                    SizedBox(width: width * 0.02),
                    const Icon(Icons.message_outlined),
                  ],
                ),
              ),
              // Stories Section
              SizedBox(
                height: height * 0.14,
                child: Stack(
                  children: [
                    // List of stories
                    Obx(() {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1 + controller.followedUserStories.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.userStoryUrls.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewStory(
                                              controller.userStoryUrls
                                                  .toList()),
                                        ),
                                      );
                                    } else {
                                      controller.pickImage();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: CircleAvatar(
                                      radius: height * 0.05,
                                      backgroundColor: Colors.grey,
                                      child: CachedNetworkImage(
                                        imageUrl: controller.userProfileImageUrl
                                                .value.isNotEmpty
                                            ? controller
                                                .userProfileImageUrl.value
                                            : 'https://via.placeholder.com/150',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(AppString.yourStory),
                                ),
                              ],
                            );
                          } else {
                            final followedUserStory =
                                controller.followedUserStories[index - 1];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewStory(
                                            followedUserStory['storyUrls']),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: CircleAvatar(
                                      radius: height * 0.05,
                                      backgroundColor: Colors.grey,
                                      child: CachedNetworkImage(
                                        imageUrl: followedUserStory[
                                                'profileImageUrl'] ??
                                            'https://via.placeholder.com/150',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(followedUserStory['username']),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }),
                    // Positioned Add Button
                    Positioned(
                      bottom: 33,
                      left: 73,
                      child: GestureDetector(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                          height: height * 0.025,
                          width: height * 0.025,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Obx(
                () => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    final postId = post['uid'];

                    final lastComment = controller.comments[postId];

                    return Container(
                      height: height * 0.55,
                      width: width * 0.9,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: height * 0.015),
                            child: Row(
                              children: [
                                Container(
                                  width: height * 0.08,
                                  height: height * 0.08,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: post['userProfileImageUrl'] ??
                                        'https://via.placeholder.com/150',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
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
                                SizedBox(width: width * 0.02),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['username'] ?? 'Username'),
                                    const Text('Location'),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.more_vert),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Container(
                            height: height * 0.36,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(post['mediaUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                // Like Button
                                GestureDetector(
                                  onTap: () {
                                    controller.toggleFavorite(index);
                                  },
                                  child: Obx(() => Icon(
                                        controller.favorites[index]
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: controller.favorites[index]
                                            ? Colors.red
                                            : Colors.black,
                                      )),
                                ),
                                SizedBox(width: width * 0.03),

                                GestureDetector(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   isScrollControlled: true,
                                    //   builder: (context) => Padding(
                                    //     padding: EdgeInsets.only(
                                    //         bottom: MediaQuery.of(context)
                                    //             .viewInsets
                                    //             .bottom),
                                    //     child: Container(
                                    //       height: 400,
                                    //       color: Colors.red,
                                    //       child: Column(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           SizedBox(
                                    //             height: 200,
                                    //           ),
                                    //           TextField(),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CommentScreen(postId: post['uid']),
                                      ),
                                    );
                                  },
                                  child:
                                      const Icon(Icons.mode_comment_outlined),
                                ),
                                SizedBox(width: width * 0.03),

                                const Icon(Icons.send_outlined),
                                const Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    controller.toggleBookmark(index);
                                  },
                                  child: Obx(
                                    () => Icon(
                                      controller.saved[index]
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: controller.saved[index]
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: lastComment != null
                                ? Text(
                                    '${lastComment['username']}  ${lastComment['comment']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  )
                                : Text(
                                    AppString.noCommentsYet,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
