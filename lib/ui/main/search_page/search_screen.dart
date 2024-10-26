import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/search_controller.dart';
import 'package:instagram/ui/main/search_page/video_player.dart';

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 42,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchFieldController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: AppString.search,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    searchController.searchUsers(value);
                  },
                  onTap: () {
                    searchController.showSearchResults(true);
                  },
                ),
              ),
            ),
            Obx(
              () {
                if (searchController.searchResults.isEmpty &&
                    searchFieldController.text.isNotEmpty) {
                  return const Center(child: Text(AppString.noUsersFound));
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
                                  color:
                                      isFollowing ? Colors.white : Colors.blue,
                                  textColor:
                                      isFollowing ? Colors.black : Colors.white,
                                  onPressed: () {
                                    searchController.toggleFollow(user['uid']);
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
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 3.0,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
