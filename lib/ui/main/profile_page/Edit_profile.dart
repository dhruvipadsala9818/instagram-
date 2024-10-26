import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/controllers/edit_profile_controller.dart';
import 'package:instagram/widgets/common_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  final EditProfileController _controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.editProfile),
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
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _controller.pickImage,
                        child: Obx(() {
                          return Container(
                            height: height * 0.15,
                            width: height * 0.15,
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
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Text(
                        AppString.editPicture,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    CommonTextField(
                      controller: _controller.usernameController,
                      labelText: AppString.username,
                    ),
                    SizedBox(height: height * 0.015),
                    CommonTextField(
                      controller: _controller.emailController,
                      labelText: AppString.email,
                    ),
                    SizedBox(height: height * 0.015),
                    CommonTextField(
                      controller: _controller.pronounsController,
                      labelText: AppString.pronouns,
                    ),
                    SizedBox(height: height * 0.015),
                    CommonTextField(
                      controller: _controller.bioController,
                      labelText: AppString.bio,
                    ),
                    SizedBox(height: height * 0.02),
                    const Text(AppString.addLink,
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: height * 0.02),
                    const Text(AppString.addBanners,
                        style: TextStyle(fontSize: 16)),
                    CommonTextField(
                      controller: _controller.pronounsController,
                      labelText: AppString.gender,
                      suffixIcon: const Icon(Icons.arrow_forward_ios, size: 17),
                    ),
                    SizedBox(height: height * 0.025),
                    Obx(
                      () {
                        return Row(
                          children: [
                            const Text(
                              AppString.showThread,
                              style: TextStyle(fontSize: 17),
                            ),
                            const Spacer(),
                            Switch(
                              value: _controller.isSwitched.value,
                              onChanged: _controller.toggleSwitch,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: height * 0.015),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: height * 0.05, color: Colors.grey.shade200),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      AppString.switchProfessional,
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                  Divider(height: height * 0.05, color: Colors.grey.shade200),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      AppString.personalInfo,
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
