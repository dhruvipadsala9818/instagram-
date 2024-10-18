import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';

import 'controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  final SearchScreenController searchController =
      Get.put(SearchScreenController());
  final TextEditingController searchFieldController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: searchFieldController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  searchController.searchUsers(value);
                },
                onTap: () {
                  searchController.showSearchResults(true);
                },
              ),
              Obx(
                () {
                  if (searchController.searchResults.isEmpty &&
                      searchFieldController.text.isNotEmpty) {
                    return const Center(child: Text('No users found'));
                  } else if (searchFieldController.text.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchController.searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchController.searchResults[index];
                        final currentUser = FirebaseAuth.instance.currentUser;

                        return ListTile(
                          leading: user['profileImageUrl'] != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user['profileImageUrl']),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          title: Text(user['username']),
                          subtitle: Text(user['email']),
                          trailing: currentUser?.uid != user['uid']
                              ? Obx(() {
                                  bool isFollowing =
                                      searchController.isFollowing(user['uid']);
                                  return MaterialButton(
                                    height: screenHeight * 0.04,
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide(
                                          color: isFollowing
                                              ? Colors.black
                                              : Colors.blue),
                                    ),
                                    color: isFollowing
                                        ? Colors.white
                                        : Colors.blue,
                                    textColor: isFollowing
                                        ? Colors.black
                                        : Colors.white,
                                    onPressed: () {
                                      searchController
                                          .toggleFollow(user['uid']);
                                    },
                                    child: Text(
                                        isFollowing ? 'Following' : 'Follow'),
                                  );
                                })
                              : null,
                        );
                      },
                    );
                  } else {
                    return Expanded(
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 3,
                        itemCount: searchController.allPostsAndReels.length,
                        itemBuilder: (context, index) {
                          final postOrReel =
                              searchController.allPostsAndReels[index];

                          if (postOrReel['type'] == 'image') {
                            return CachedNetworkImage(
                              imageUrl: postOrReel['mediaUrl'],
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                              fit: BoxFit.cover,
                            );
                          } else if (postOrReel['type'] == 'video') {
                            return VideoPlayerWidget(
                                videoUrl: postOrReel['mediaUrl']);
                          }

                          return const SizedBox.shrink();
                        },
                        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const SizedBox.shrink(); // No loading spinner here
  }
}
