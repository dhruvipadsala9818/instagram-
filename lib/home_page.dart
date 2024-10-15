// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:story_view/controller/story_controller.dart';
// import 'package:story_view/widgets/story_view.dart';
//
// import 'controllers/home_controller.dart';
//
// class HomePage extends StatelessWidget {
//   final HomeController controller = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       'assets/images/insta-text.png',
//                       scale: 3.5,
//                     ),
//                     const Icon(Icons.keyboard_arrow_down_outlined),
//                     const Spacer(),
//                     const Icon(Icons.favorite_border),
//                     SizedBox(width: width * 0.02),
//                     const Icon(Icons.message_outlined),
//                   ],
//                 ),
//               ),
//               // Stories Section
//               SizedBox(
//                 height: height * 0.15,
//                 child: Obx(() {
//                   // If no stories are available, show a placeholder
//                   if (controller.userStoryUrls.isEmpty &&
//                       controller.followedUserStories.isEmpty) {
//                     return Center(child: Text('No stories available'));
//                   } else {
//                     return ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 1 +
//                           controller.followedUserStories
//                               .length, // Add the user's story plus followed users' stories
//                       itemBuilder: (context, index) {
//                         if (index == 0) {
//                           // Current user's story
//                           return Column(
//                             children: [
//                               Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       if (controller.userStoryUrls.isNotEmpty) {
//                                         // If stories exist, show them
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ViewStory(
//                                               controller.userStoryUrls.toList(),
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         // Otherwise, allow the user to add a new story
//                                         controller.pickImage();
//                                       }
//                                     },
//                                     child: Container(
//                                       height: height * 0.1,
//                                       width: height * 0.1,
//                                       margin:
//                                           EdgeInsets.only(left: width * 0.04),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.grey,
//                                       ),
//                                       child: CachedNetworkImage(
//                                         imageUrl: controller.userProfileImageUrl
//                                                     .value !=
//                                                 ''
//                                             ? controller
//                                                 .userProfileImageUrl.value
//                                             : 'https://via.placeholder.com/150',
//                                         imageBuilder:
//                                             (context, imageProvider) =>
//                                                 Container(
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             image: DecorationImage(
//                                               image: imageProvider,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         placeholder: (context, url) =>
//                                             const CircularProgressIndicator(),
//                                         errorWidget: (context, url, error) =>
//                                             const Icon(Icons.error),
//                                       ),
//                                     ),
//                                   ),
//                                   if (controller.userStoryUrls
//                                       .isEmpty) // Show "+" if no story
//                                     Positioned(
//                                       bottom: 2,
//                                       right: 1,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           controller
//                                               .pickImage(); // Allow user to pick image
//                                         },
//                                         child: Container(
//                                           height: height * 0.03,
//                                           width: height * 0.03,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Colors.blue,
//                                             border:
//                                                 Border.all(color: Colors.white),
//                                           ),
//                                           child: const Icon(Icons.add,
//                                               color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               const Text('Your story'),
//                             ],
//                           );
//                         } else {
//                           // Followed user's story
//                           final followedUserStory =
//                               controller.followedUserStories[index - 1];
//                           return Column(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ViewStory(
//                                           followedUserStory['storyUrls']),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: height * 0.1,
//                                   width: height * 0.1,
//                                   margin: EdgeInsets.only(left: width * 0.04),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.grey,
//                                   ),
//                                   child: CachedNetworkImage(
//                                     imageUrl:
//                                         followedUserStory['profileImageUrl'] ??
//                                             'https://via.placeholder.com/150',
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     placeholder: (context, url) =>
//                                         const CircularProgressIndicator(),
//                                     errorWidget: (context, url, error) =>
//                                         const Icon(Icons.error),
//                                   ),
//                                 ),
//                               ),
//                               Text(followedUserStory['username']),
//                             ],
//                           );
//                         }
//                       },
//                     );
//                   }
//                 }),
//               ),
//               // Posts Section
//               Obx(
//                 () => ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: controller.posts.length,
//                   itemBuilder: (context, index) {
//                     final post = controller.posts[index];
//                     return Container(
//                       height: height * 0.51,
//                       width: width * 0.9,
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: height * 0.015),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: height * 0.08,
//                                   height: height * 0.08,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.grey,
//                                   ),
//                                   child: CachedNetworkImage(
//                                     imageUrl: post['userProfileImageUrl'] ??
//                                         'https://via.placeholder.com/150',
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     placeholder: (context, url) =>
//                                         const CircularProgressIndicator(),
//                                     errorWidget: (context, url, error) =>
//                                         const Icon(Icons.error),
//                                   ),
//                                 ),
//                                 SizedBox(width: width * 0.02),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(post['username'] ?? 'Username'),
//                                     const Text('Location'),
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 const Icon(Icons.more_vert),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: height * 0.01),
//                           Container(
//                             height: height * 0.36,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(post['image']),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height * 0.01),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     controller.toggleFavorite(index);
//                                   },
//                                   child: Obx(() => Icon(
//                                         controller.favorites[index]
//                                             ? Icons.favorite
//                                             : Icons.favorite_border,
//                                         color: controller.favorites[index]
//                                             ? Colors.red
//                                             : Colors.black,
//                                       )),
//                                 ),
//                                 SizedBox(width: width * 0.03),
//                                 const Icon(Icons.mode_comment_outlined),
//                                 SizedBox(width: width * 0.03),
//                                 const Icon(Icons.send_outlined),
//                                 const Spacer(),
//                                 GestureDetector(
//                                   onTap: () {
//                                     controller.toggleBookmark(index);
//                                   },
//                                   child: Obx(
//                                     () => Icon(
//                                       controller.saved[index]
//                                           ? Icons.bookmark
//                                           : Icons.bookmark_border,
//                                       color: controller.saved[index]
//                                           ? Colors.black
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ViewStory extends StatefulWidget {
//   final List storyUrls;
//
//   ViewStory(this.storyUrls);
//
//   @override
//   _ViewStoryState createState() => _ViewStoryState();
// }
//
// class _ViewStoryState extends State<ViewStory> {
//   final StoryController storyController = StoryController();
//
//   @override
//   void dispose() {
//     storyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Story"),
//       ),
//       body: StoryView(
//         storyItems: widget.storyUrls.map((url) {
//           return StoryItem.pageImage(
//             url: url,
//             caption: Text(
//               "Story",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             controller: storyController,
//           );
//         }).toList(),
//         onComplete: () {
//           Navigator.pop(context);
//         },
//         progressPosition: ProgressPosition.top,
//         repeat: false,
//         controller: storyController,
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ins'
                      'ta-text.png',
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
                height: height * 0.15,
                child: Stack(
                  children: [
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
                                    padding: const EdgeInsets.only(left: 10),
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
                                const Text("Your story"),
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
                                Text(followedUserStory['username']),
                              ],
                            );
                          }
                        },
                      );
                    }),
                    Positioned(
                      top: 54,
                      left: 60,
                      child: GestureDetector(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                          height: height * 0.03,
                          width: height * 0.03,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
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
                    return Container(
                      height: height * 0.51,
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
                                image: NetworkImage(post['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
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
                                const Icon(Icons.mode_comment_outlined),
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

class ViewStory extends StatefulWidget {
  final List storyUrls;

  ViewStory(this.storyUrls);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  final StoryController storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Story"),
      ),
      body: StoryView(
        storyItems: widget.storyUrls.map((url) {
          return StoryItem.pageImage(
            url: url,
            caption: Text(
              "Story",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            controller: storyController,
          );
        }).toList(),
        onComplete: () {
          Navigator.pop(context);
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
