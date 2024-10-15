import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final EditProfileController _controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get screen size
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _controller.saveProfile,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04), // Dynamic padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture section
                    Center(
                      child: GestureDetector(
                        onTap: _controller.pickImage,
                        child: Obx(() {
                          return Container(
                            height: height * 0.15, // 15% of screen height
                            width: height *
                                0.15, // 15% of screen height for the circular profile image
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: _controller.image.value != null
                                  ? DecorationImage(
                                      image:
                                          FileImage(_controller.image.value!),
                                      fit: BoxFit.cover,
                                    )
                                  : _controller.profileImageUrl.value.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(_controller
                                              .profileImageUrl.value),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: height * 0.02), // Dynamic spacing
                    const Center(
                      child: Text(
                        "Edit Picture or Avatar",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04), // Dynamic spacing

                    // Username TextField
                    TextField(
                      controller: _controller.usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: width * 0.04, // Dynamic font size
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015), // Dynamic spacing

                    // Email TextField
                    TextField(
                      controller: _controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: width * 0.04, // Dynamic font size
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015), // Dynamic spacing

                    // Pronouns TextField
                    TextField(
                      controller: _controller.pronounsController,
                      decoration: InputDecoration(
                        labelText: "Pronouns",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: width * 0.04, // Dynamic font size
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015), // Dynamic spacing

                    // Bio TextField
                    TextField(
                      controller: _controller.bioController,
                      decoration: InputDecoration(
                        labelText: "Bio",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: width * 0.04, // Dynamic font size
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02), // Dynamic spacing

                    // Add link and banners section
                    const Text("Add link", style: TextStyle(fontSize: 16)),
                    SizedBox(height: height * 0.02),
                    const Text("Add banners", style: TextStyle(fontSize: 16)),

                    // Gender TextField
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon:
                            const Icon(Icons.arrow_forward_ios, size: 17),
                        labelText: "Gender",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: width * 0.04, // Dynamic font size
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025), // Dynamic spacing

                    // Switch for thread badge
                    Obx(() {
                      return Row(
                        children: [
                          const Text(
                            "Show Thread badge",
                            style: TextStyle(fontSize: 17),
                          ),
                          const Spacer(),
                          Switch(
                            value: _controller.isSwitched.value,
                            onChanged: _controller.toggleSwitch,
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: height * 0.015), // Dynamic spacing
                  ],
                ),
              ),

              // Divider and additional sections
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: height * 0.05, color: Colors.grey.shade200),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Switch to professional account",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                  Divider(height: height * 0.05, color: Colors.grey.shade200),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Personal information setting",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                  Divider(height: height * 0.05, color: Colors.grey.shade200),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
