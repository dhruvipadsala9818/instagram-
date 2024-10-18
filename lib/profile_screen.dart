// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram/reels_screen.dart';
// import 'package:instagram/setting_screen.dart';
// import 'package:provider/provider.dart';
//
// import 'Edit_profile.dart';
// import 'controllers/post_controller.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: screenHeight * 0.04),
//               ChangeNotifierProvider(
//                 create: (_) => UserController(),
//                 child: Consumer<UserController>(
//                   builder: (context, userController, child) {
//                     if (userController.isLoading) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//
//                     var userData = userController.userData;
//                     String email = userData['email'] ?? 'No email';
//                     String username = userData['username'] ?? 'No username';
//                     String? profileImageUrl = userData['imageUrl'];
//
//                     return Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: screenWidth * 0.06),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.lock_outline, size: 17),
//                                   Text(' $email',
//                                       style: TextStyle(fontSize: 20)),
//                                   SizedBox(width: 5),
//                                   Icon(Icons.keyboard_arrow_down_sharp,
//                                       size: 17),
//                                   Spacer(),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => SettingScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Icon(Icons.menu, size: 18),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: screenHeight * 0.06),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Stack(
//                                     clipBehavior: Clip.none,
//                                     children: [
//                                       Container(
//                                         width: screenWidth * 0.26,
//                                         height: screenWidth * 0.26,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.grey[200],
//                                         ),
//                                         child: CachedNetworkImage(
//                                           imageUrl: profileImageUrl != null
//                                               ? profileImageUrl
//                                               : '',
//                                           imageBuilder:
//                                               (context, imageProvider) =>
//                                                   Container(
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               image: DecorationImage(
//                                                 image: imageProvider,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           placeholder: (context, url) => Center(
//                                               child:
//                                                   CircularProgressIndicator()),
//                                           errorWidget: (context, url, error) =>
//                                               Icon(Icons.error),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 70,
//                                         top: 70,
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           decoration: BoxDecoration(
//                                             color: Colors.blue,
//                                             shape: BoxShape.circle,
//                                             border: Border.all(
//                                                 color: Colors.white, width: 2),
//                                           ),
//                                           child: Icon(Icons.add,
//                                               color: Colors.white, size: 16),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 19,
//                                         top: -20,
//                                         child: Container(
//                                           height: 40,
//                                           width: 65,
//                                           decoration: BoxDecoration(
//                                               color: Colors.grey,
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 'current',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 'vibe?',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(children: [
//                                     Text('${userController.posts.length}'),
//                                     Text('posts')
//                                   ]),
//                                   Column(
//                                     children: [
//                                       Text(
//                                           '${userController.followers.length}'), // Display follower count
//                                       Text('followers'),
//                                     ],
//                                   ),
//                                   Column(
//                                     children: [
//                                       Text(
//                                           '${userController.following.length}'), // Display following count
//                                       Text('following'),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: screenHeight * 0.02),
//                               Text('$username', style: TextStyle(fontSize: 16)),
//                               SizedBox(height: screenHeight * 0.02),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 EditProfileScreen(),
//                                           ));
//                                     },
//                                     child: Container(
//                                       height: 35,
//                                       width: 130,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade300,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Edit Profile',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 15),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {},
//                                     child: Container(
//                                       height: 35,
//                                       width: 130,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade300,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Share Profile',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 15),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {},
//                                     child: Container(
//                                       height: 35,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade300,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Center(
//                                         child: Icon(Icons.person_outlined),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.03,
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     height: 60,
//                                     width: 60,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                           color: Colors.grey.shade600),
//                                     ),
//                                     child: Icon(
//                                       Icons.add,
//                                       size: 28,
//                                     ),
//                                   ),
//                                   Text('New'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         DefaultTabController(
//                           length: 3,
//                           child: Column(
//                             children: [
//                               TabBar(
//                                 indicatorColor: Colors.blue,
//                                 indicatorSize: TabBarIndicatorSize.tab,
//                                 dividerColor: Colors.transparent,
//                                 labelColor: Colors.blue,
//                                 tabs: [
//                                   Tab(icon: Icon(Icons.grid_on)),
//                                   Tab(icon: Icon(Icons.video_collection)),
//                                   Tab(icon: Icon(Icons.person_pin)),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height:
//                                     300, // Adjust height as needed for TabBarView
//                                 child: TabBarView(
//                                   children: [
//                                     // Posts Tab
//                                     GridView.builder(
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 3,
//                                         crossAxisSpacing: 4.0,
//                                         mainAxisSpacing: 4.0,
//                                       ),
//                                       itemCount: userController.posts.length,
//                                       itemBuilder: (context, index) {
//                                         final post =
//                                             userController.posts[index];
//                                         return Container(
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               image: NetworkImage(
//                                                   post['imageUrl']),
//                                               fit: BoxFit.cover,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     // Reels Tab
//                                     GridView.builder(
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 3,
//                                         mainAxisSpacing: 4.0,
//                                         crossAxisSpacing: 4.0,
//                                         childAspectRatio: 0.65,
//                                       ),
//                                       itemCount: userController.reels.length,
//                                       itemBuilder: (context, index) {
//                                         final reel =
//                                             userController.reels[index];
//                                         return ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Container(
//                                             color: Colors.black,
//                                             child: Stack(
//                                               children: [
//                                                 Positioned.fill(
//                                                   child: VideoPlayerWidget(
//                                                       videoUrl:
//                                                           reel['videoUrl']),
//                                                 ),
//                                                 Positioned(
//                                                   bottom: 10,
//                                                   // right: 10,
//                                                   child: Icon(
//                                                     Icons.play_arrow_outlined,
//                                                     color: Colors.white,
//                                                     size: 25,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     // Tagged Tab
//                                     Center(child: Text('Tagged content here')),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagram/reels_screen.dart';
import 'package:instagram/setting_screen.dart';
import 'package:provider/provider.dart';
import 'Edit_profile.dart';
import 'controllers/post_controller.dart';
import 'controllers/search_controller.dart';

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
                                  Icon(Icons.lock_outline, size: 17),
                                  Text(' $email',
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 5),
                                  Icon(Icons.keyboard_arrow_down_sharp,
                                      size: 17),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SettingScreen(),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.menu, size: 18),
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
                                            width: screenWidth *
                                                0.26, // Circle diameter
                                            height: screenWidth * 0.26,
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: screenWidth * 0.26,
                                            height: screenWidth * 0.26,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.person,
                                                size: screenWidth *
                                                    0.08), // Placeholder icon
                                          ),
                                          width: screenWidth * 0.26,
                                          height: screenWidth * 0.26,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 1,
                                        bottom: 6,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: Icon(Icons.add,
                                              color: Colors.white, size: 16),
                                        ),
                                      ),
                                      Positioned(
                                        left: 19,
                                        top: -20,
                                        child: Container(
                                          height: 40,
                                          width: 65,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'current',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'vibe?',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(children: [
                                    Text('${userController.posts.length}'),
                                    Text('posts')
                                  ]),
                                  Spacer(),
                                  Column(
                                    children: [
                                      //Text('0'),
                                      Obx(() {
                                        int followersCount =
                                            searchController.followers.length;
                                        return Text(
                                          '$followersCount',
                                        );
                                      }),

                                      Text('followers'),
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
                                          );
                                        },
                                      ),
                                      // Text("0"),
                                      Text('following'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text('$username',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen(),
                                          ));
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 35,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Share Profile',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 35,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.person_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade600),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                  Text('New'),
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
                                dividerColor: Colors.transparent,
                                labelColor: Colors.blue,
                                tabs: [
                                  Tab(icon: Icon(Icons.grid_on)),
                                  Tab(icon: Icon(Icons.video_collection)),
                                  Tab(icon: Icon(Icons.person_pin)),
                                ],
                              ),
                              SizedBox(
                                height: 300,
                                child: TabBarView(
                                  children: [
                                    // Posts Tab
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
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

                                    // Reels Tab
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
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
                                                  bottom: 10,
                                                  // right: 10,
                                                  child: Icon(
                                                    Icons.play_arrow_outlined,
                                                    color: Colors.white,
                                                    size: 25,
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
