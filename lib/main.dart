import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/ui/main/bottombar/bottom_nav_bar.dart';
import 'package:instagram/ui/main/profile_page/profile_screen.dart';

import 'ui/startup/Auth/login_screen.dart';

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
