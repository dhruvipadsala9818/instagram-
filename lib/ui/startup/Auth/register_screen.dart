import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram/constant/app_assets.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/helper/helper.dart';
import 'package:instagram/ui/main/bottombar/bottom_nav_bar.dart';
import 'package:instagram/controllers/home_controller.dart';
import 'package:instagram/widgets/common_text_field.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const String defaultProfileImageUrl =
      'https://example.com/default_profile_image.png';

  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('InstaUser')
              .doc(user.uid)
              .set({
            'email': email,
            'username': username,
            'imageUrl': defaultProfileImageUrl,
            'pronouns': '',
            'bio': '',
          });

          Helper.dialogCall.showToast(
              context, AppString.registerSuccess, Colors.black, Colors.white);

          HomeController homeController = Get.put(HomeController());
          await homeController.fetchProfile();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
        }
      } catch (e) {
        Helper.dialogCall.showToast(context,
            '${AppString.error} ${e.toString()}', Colors.black, Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: screenSize.height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height * 0.1,
                  ),
                  Center(
                    child: Image.asset(
                      AppAssets.instagram,
                      scale: isPortrait ? 8 : 12,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    AppString.createAcc,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    controller: _emailController,
                    hintText: AppString.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterEmail;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return AppString.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    controller: _usernameController,
                    hintText: AppString.username,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterUsername;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: AppString.password,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.pleaseEnterPassword;
                      }
                      if (value.length < 6) {
                        return AppString.passwordCharacter;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  MaterialButton(
                    height: screenHeight * 0.06,
                    minWidth: double.infinity,
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide.none,
                    ),
                    onPressed: () => _registerUser(context),
                    child: Text(
                      AppString.register,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      AppString.alreadyHaveAcc,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
