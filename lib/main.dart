import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/Auth/login_screen.dart';
import 'package:instagram/bottom_nav_bar.dart';
import 'package:instagram/controllers/home_controller.dart';
import 'package:instagram/profile_screen.dart';
import 'package:instagram/stories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GetStorage box = GetStorage();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    String? uid = box.read('uid');

    return GetMaterialApp(
      getPages: [
        GetPage(name: '/profile', page: () => ProfileScreen()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Instagram',
      navigatorKey: navigatorKey,
      home: uid == null ? LogInScreen() : BottomNavBar(),
      // home: MoreStories(),
    );
  }
}
