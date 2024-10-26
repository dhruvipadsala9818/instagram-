import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/post_controller.dart';
import 'package:instagram/controllers/search_controller.dart';
import 'package:instagram/ui/main/reels_page/reels_screen.dart';
import 'package:instagram/ui/startup/Auth/logout_screen.dart';
import 'package:provider/provider.dart';
import 'Edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: user.uid)
          .get();

      setState(() {
        posts = snapshot.docs.map((doc) {
          return {'image': doc['mediaUrl'], 'uid': doc['uid']};
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final SearchScreenController searchController =
        Get.put(SearchScreenController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),
              ChangeNotifierProvider(
                create: (_) => UserController(),
                child: Consumer<UserController>(
                  builder: (context, userController, child) {
                    if (userController.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var userData = userController.userData;
                    String email = userData['email'] ?? 'No email';
                    String username = userData['username'] ?? 'No username';
                    String? profileImageUrl = userData['imageUrl'];

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lock_outline,
                                      size: screenWidth * 0.045),
                                  Text(' $email',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05)),
                                  SizedBox(width: screenWidth * 0.02),
                                  Icon(Icons.keyboard_arrow_down_sharp,
                                      size: screenWidth * 0.045),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(LogoutScreen());
                                    },
                                    child: Icon(Icons.menu,
                                        size: screenWidth * 0.075),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: profileImageUrl ?? '',
                                          placeholder: (context, url) =>
                                              Container(
                                            width: screenWidth * 0.26,
                                            height: screenWidth * 0.26,
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.white,
                                                size: screenWidth * 0.1,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: screenWidth * 0.26,
                                            height: screenWidth * 0.26,
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.person,
                                              size: screenWidth * 0.08,
                                            ),
                                          ),
                                          width: screenWidth * 0.26,
                                          height: screenWidth * 0.26,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: screenWidth * 0.02,
                                        bottom: screenHeight * 0.007,
                                        child: Container(
                                          height: screenHeight * 0.03,
                                          width: screenWidth * 0.07,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: Icon(Icons.add,
                                              color: Colors.white,
                                              size: screenWidth * 0.04),
                                        ),
                                      ),
                                      Positioned(
                                        left: screenWidth * 0.05,
                                        top: -screenHeight * 0.03,
                                        child: Container(
                                          height: screenHeight * 0.06,
                                          width: screenWidth * 0.18,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppString.current,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: screenWidth * 0.03,
                                                ),
                                              ),
                                              Text(
                                                AppString.vibe,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: screenWidth * 0.03,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Text('${userController.posts.length}',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold)),
                                      Text(AppString.posts,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035)),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Obx(() {
                                        int followersCount =
                                            searchController.followers.length;
                                        return Text(
                                          '$followersCount',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                      Text(AppString.follower,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035)),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Obx(
                                        () {
                                          int followingCount = searchController
                                              .followingUsers.length;
                                          return Text(
                                            '$followingCount',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                      Text(AppString.following,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text('$username',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(EditProfileScreen());
                                    },
                                    child: Container(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.35,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppString.editProfile,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.04),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.35,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppString.shareProfile,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.04),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.12,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.person_outlined,
                                            size: screenWidth * 0.06),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Column(
                                children: [
                                  Container(
                                    height: screenHeight * 0.08,
                                    width: screenHeight * 0.08,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade600),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: screenWidth * 0.07,
                                    ),
                                  ),
                                  Text('New',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                indicatorColor: Colors.blue,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.blue,
                                dividerColor: Colors.transparent,
                                tabs: [
                                  Tab(
                                      icon: Icon(Icons.grid_on_outlined,
                                          size: screenWidth * 0.06)),
                                  Tab(
                                      icon: Icon(Icons.video_collection,
                                          size: screenWidth * 0.06)),
                                  Tab(
                                      icon: Icon(Icons.person_pin,
                                          size: screenWidth * 0.06)),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.4,
                                child: TabBarView(
                                  children: [
                                    // Posts Tab
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: screenWidth * 0.01,
                                        mainAxisSpacing: screenWidth * 0.01,
                                      ),
                                      itemCount: userController.posts.length,
                                      itemBuilder: (context, index) {
                                        final post =
                                            userController.posts[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  post['mediaUrl']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // Reels
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: screenWidth * 0.01,
                                        crossAxisSpacing: screenWidth * 0.01,
                                        childAspectRatio: 0.65,
                                      ),
                                      itemCount: userController.reels.length,
                                      itemBuilder: (context, index) {
                                        final reel =
                                            userController.reels[index];
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            color: Colors.black,
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: VideoPlayerWidget(
                                                      videoUrl:
                                                          reel['mediaUrl']),
                                                ),
                                                Positioned(
                                                  bottom: screenHeight * 0.01,
                                                  child: Icon(
                                                    Icons.play_arrow_outlined,
                                                    color: Colors.white,
                                                    size: screenWidth * 0.06,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // Tagged Tab

                                    Center(child: Text('Tagged content here')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
