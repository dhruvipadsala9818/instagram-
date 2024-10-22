import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/controllers/home_controller.dart';
import 'package:instagram/ui/main/save_post/saved_posts.dart';

import 'login_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final HomeController controller = Get.find();
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    box.erase();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen(),
                        ),
                        (route) => false);
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Center(
                child: TextButton(
                  child: const Text(
                    'Saved Posts',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedPostsPage(),
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
