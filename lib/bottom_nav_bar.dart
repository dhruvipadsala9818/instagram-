import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/reels_screen.dart';
import 'package:video_player/video_player.dart';

import 'controllers/add_post_controller.dart';
import 'controllers/home_controller.dart';
import 'home_page.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

final HomeController controller = Get.put(HomeController());
final AddPostController addPostController = Get.put(AddPostController());
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _BottomNavBarState extends State<BottomNavBar> {
  ValueNotifier<PlatformFile?> image = ValueNotifier<PlatformFile?>(null);
  ValueNotifier<PlatformFile?> video = ValueNotifier<PlatformFile?>(null);
  List<Widget> screenname = [
    HomePage(),
    SearchScreen(),
    Container(),
    ReelsScreen(),
    ProfileScreen(),
  ];

  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedScreen,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.smart_display_outlined, size: 30), label: ""),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: height * 0.02,
              backgroundColor: Colors.grey,
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            label: "",
          ),
        ],
        onTap: (value) {
          if (value == 2) {
            // Open gallery to select an image or video
            pickMedia();
          } else {
            // Update selected screen for other tabs
            setState(() {
              selectedScreen = value;
            });
          }
        },
      ),
      body: screenname[selectedScreen],
    );
  }

  void _pickMedia() async {
    final ImagePicker picker = ImagePicker();

    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      Get.to(() => MediaPreviewScreen(mediaFile: selectedImage));
      return;
    }

    final XFile? selectedVideo =
        await picker.pickVideo(source: ImageSource.gallery);
    if (selectedVideo != null) {
      Get.to(() => MediaPreviewScreen(mediaFile: selectedVideo));
    }
  }

  void pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (result != null) {
      final pickedFile = result.files.first;

      // Convert PlatformFile to XFile
      final xFile = XFile(pickedFile.path!);

      if (pickedFile.extension == 'jpg' ||
          pickedFile.extension == 'png' ||
          pickedFile.extension == 'jpeg') {
        image.value = pickedFile;
        // Navigate to MediaPreviewScreen
        Get.to(() => MediaPreviewScreen(mediaFile: xFile));
      } else if (pickedFile.extension == 'mp4' ||
          pickedFile.extension == 'mov' ||
          pickedFile.extension == 'avi') {
        video.value = pickedFile;
        // Navigate to MediaPreviewScreen
        Get.to(() => MediaPreviewScreen(mediaFile: xFile));
      }
    } else {
      print("No media selected");
    }
  }

// Future<void> pickMedia() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.media,
//     allowMultiple: false,
//   );
//
//   if (result != null) {
//     final pickedFile = result.files.first;
//
//     if (pickedFile.extension == 'jpg' ||
//         pickedFile.extension == 'png' ||
//         pickedFile.extension == 'jpeg') {
//       image.value = pickedFile;
//     } else if (pickedFile.extension == 'mp4' ||
//         pickedFile.extension == 'mov' ||
//         pickedFile.extension == 'avi') {
//       video.value = pickedFile;
//     }
//   } else {
//     print("No media selected");
//   }
// }
}

class MediaPreviewScreen extends StatelessWidget {
  final XFile mediaFile;

  MediaPreviewScreen({required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    bool isImage =
        mediaFile.mimeType != null && mediaFile.mimeType!.startsWith('image/');

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: isImage
                ? Container(
                    height: 400,
                    width: double.infinity, // Full width
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(mediaFile.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : VideoPlayerScreen(videoFile: mediaFile),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            height: 50,
            minWidth: 100,
            color: Colors.grey,
            child: Text(
              "Post",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              _uploadMedia(mediaFile);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _uploadMedia(XFile mediaFile) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "User not authenticated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    String? mimeType = mediaFile.mimeType;

    if (mimeType == null) {
      String fileExtension = mediaFile.path.split('.').last.toLowerCase();
      mimeType = _getMimeType(fileExtension);
      if (mimeType == null) {
        Fluttertoast.showToast(
          msg: "Unsupported file type",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }

    DocumentSnapshot snapshot =
        await _firestore.collection('InstaUser').doc(user.uid).get();

    String username = snapshot.exists && snapshot.data() != null
        ? (snapshot.data() as Map<String, dynamic>)['username'] ??
            'Unknown User'
        : 'Unknown User';

    String userProfileImageUrl = snapshot.exists && snapshot.data() != null
        ? (snapshot.data() as Map<String, dynamic>)['imageUrl'] ?? ''
        : '';

    String filePath =
        'media/${DateTime.now().millisecondsSinceEpoch}.$mimeType';
    Reference ref = FirebaseStorage.instance.ref().child(filePath);

    await ref.putFile(File(mediaFile.path));

    String downloadUrl = await ref.getDownloadURL();

    if (mimeType.startsWith('image/')) {
      await FirebaseFirestore.instance.collection('posts').add({
        'mediaUrl': downloadUrl,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
        'userProfileImageUrl': userProfileImageUrl,
      });
      Fluttertoast.showToast(
        msg: "Image uploaded successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (mimeType.startsWith('video/')) {
      await FirebaseFirestore.instance.collection('reels').add({
        'mediaUrl': downloadUrl,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
        'userProfileImageUrl': userProfileImageUrl,
      });
      Fluttertoast.showToast(
        msg: "Video uploaded successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    Get.offAll(() => BottomNavBar());
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error uploading media: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

String? _getMimeType(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'mp4':
      return 'video/mp4';
    case 'mov':
      return 'video/quicktime';

    default:
      return null;
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final XFile videoFile;

  VideoPlayerScreen({required this.videoFile});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.hasError) {
      return Center(
        child: Text("Unable to play video. Please try again later."),
      );
    }

    return Center(
      child: _controller.value.isInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 650,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Positioned(
                      bottom: 350,
                      left: 186,
                      child: IconButton(
                        icon: Icon(
                          color: Colors.white,
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
