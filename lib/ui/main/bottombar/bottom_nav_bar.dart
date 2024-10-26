import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/add_post_controller.dart';
import 'package:instagram/controllers/home_controller.dart';
import 'package:instagram/ui/main/add_post_page/add_post_media_screen.dart';
import 'package:instagram/ui/main/home_page/home_page.dart';
import 'package:instagram/ui/main/profile_page/profile_screen.dart';
import 'package:instagram/ui/main/reels_page/reels_screen.dart';
import 'package:instagram/ui/main/search_page/search_screen.dart';

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
  void pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (result != null) {
      final pickedFile = result.files.first;

      final xFile = XFile(pickedFile.path!);

      if (pickedFile.extension == 'jpg' ||
          pickedFile.extension == 'png' ||
          pickedFile.extension == 'jpeg') {
        image.value = pickedFile;
        Get.to(() => MediaPreviewScreen(mediaFile: xFile));
      } else if (pickedFile.extension == 'mp4' ||
          pickedFile.extension == 'mov' ||
          pickedFile.extension == 'avi') {
        video.value = pickedFile;
        Get.to(() => MediaPreviewScreen(mediaFile: xFile));
      }
    } else {
      print('No media selected');
    }
  }

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
            pickMedia();
          } else {
            setState(() {
              selectedScreen = value;
            });
          }
        },
      ),
      body: screenname[selectedScreen],
    );
  }
}
