import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/constant/app_assets.dart';
import 'package:instagram/constant/app_string.dart';
import 'package:instagram/helper/helper.dart';
import 'package:instagram/ui/main/bottombar/bottom_nav_bar.dart';
import 'package:instagram/widgets/common_text_field.dart';

import 'register_screen.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GetStorage box = GetStorage();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      print("email$email");
      print("pass$password");

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final userId = userCredential.user!.uid;
        await box.write("uid", '${userId}');

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('InstaUser')
            .doc(userCredential.user?.uid)
            .get();

        if (userDoc.exists) {
          Helper.dialogCall.showToast(
              context, AppString.loginSuccess, Colors.black, Colors.white);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
            (route) => false,
          );
        } else {
          Helper.dialogCall.showToast(
              context, AppString.loginSuccess, Colors.black, Colors.white);
        }
      } catch (e) {
        Helper.dialogCall.showToast(context,
            '${AppString.error} ${e.toString()}', Colors.black, Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Text(
                  'English(India)',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Center(
                  child: Image.asset(
                    AppAssets.instagram,
                    height: screenWidth * 0.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: AppString.password,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.pleaseEnterPassword;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      MaterialButton(
                        height: screenHeight * 0.06,
                        minWidth: double.infinity, // Full width button
                        color: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide.none,
                        ),
                        child: Text(
                          AppString.logIn,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                        onPressed: _login,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppString.forgotPassword,
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.17),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                              ));
                        },
                        height: screenHeight * 0.07,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.lightBlue, width: 2),
                        ),
                        child: Text(
                          AppString.createAccount,
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          AppAssets.meta,
                          height: screenWidth * 0.14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
